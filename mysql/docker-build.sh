#!/bin/bash

#
# build docker image for local development
#

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo
echo ">>> Build howto:mysql image"
docker build --file "$ROOT_DIR/dockerfile" \
    --tag howto:mysql \
    --build-arg etc_mysql=/etc/mysql \
    --build-arg var_mysql=/var/mysql \
    "$ROOT_DIR"

#echo
#echo ">>> Build howto:mysql_dev image"
#docker build --file "$ROOT_DIR/dockerfile.dev" \
#    --tag howto:mysql_dev \
#    --build-arg etc_mysql=/etc/mysql \
#    --build-arg var_mysql=/var/mysql \
#    "$ROOT_DIR"

echo
echo "<<< DONE"
echo
