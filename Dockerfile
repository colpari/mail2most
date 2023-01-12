FROM golang:latest as BUILDER

RUN git clone https://github.com/magefile/mage && cd mage && go run bootstrap.go
ADD . /mail2most/
RUN cd /mail2most/ && mage build





FROM alpine:latest

Maintainer Carsten Seeger <info@casee.de>

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
RUN update-ca-certificates

RUN mkdir -vp /mail2most/conf
ADD container-init.sh /

WORKDIR /mail2most
COPY --from=BUILDER /mail2most/bin/mail2most /mail2most/mail2most

ENTRYPOINT ["/bin/sh", "/container-init.sh"]
