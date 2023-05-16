#!/bin/bash

set -e

CONFDIR=$(readlink -e "$1")

docker run -v "$CONFDIR:/mail2most/conf/:ro" -it m2m 
