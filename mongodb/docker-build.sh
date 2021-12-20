#!/bin/bash

#
# build docker image for local development
#

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo
echo ">>> Build howto:mongo image"
docker build --file "$ROOT_DIR/dockerfile" \
    --tag howto:mongo \
    --build-arg etc_mongo=/etc/mongo \
    --build-arg var_mongo=/var/mongo \
    "$ROOT_DIR"

echo
echo ">>> Build howto:mongo_dev image"
docker build --file "$ROOT_DIR/dockerfile.dev" \
    --tag howto:mongo_dev \
    --build-arg etc_mongo=/etc/mongo \
    --build-arg var_mongo=/var/mongo \
    "$ROOT_DIR"

echo
echo "<<< DONE"
echo
