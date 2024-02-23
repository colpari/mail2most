#!/bin/bash

set -e

CONFDIR=$(readlink -e "$1")

docker run --rm -v "$CONFDIR:/mail2most/conf/:ro" -it containers.colpari.dev/mattermost/mail2most:latest
