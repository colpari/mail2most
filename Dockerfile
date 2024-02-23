FROM golang:latest as BUILDER

RUN git clone https://github.com/magefile/mage && cd mage && go run bootstrap.go
ADD . /mail2most/
RUN cd /mail2most/ && mage build



FROM alpine:latest

Maintainer Frank Fricke <frank.fricke@colpari.cx>

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
RUN update-ca-certificates

RUN mkdir -vp /mail2most/conf/ /mail2most/state/
ADD container-init.sh /

RUN chown 1000:1000 /mail2most/state/ && chmod 700 /mail2most/state/

VOLUME /mail2most/state/

USER 1000:1000

WORKDIR /mail2most
COPY --from=BUILDER /mail2most/bin/mail2most /mail2most/mail2most

ENTRYPOINT ["/bin/sh", "/container-init.sh"]
