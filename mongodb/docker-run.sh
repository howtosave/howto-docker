#!/bin/bash
#
# run docker image for local development
#

CONTAINRER_NAME=mongo-dev
LOCAL_BIND_PORT=17017

_usage() {
    echo
    echo 'Usage: ./docker-run.sh <run_params>'
    echo '  <run_params>   params for docker-run'
    echo '      --rm       run with temp container(default)'
    echo '      --detach   run in background and print container ID'
    echo
    echo ' to start an interactive shell for the running container'
    echo '    $ docker exec -it mongo-dev bash'
    echo
    echo ' to verify a mongodb connection'
    echo '    $ mongo --verbose mongodb://myroot:myroot00@localhost:17017/admin'
}

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#
# arguments
#

_OPTS="--rm ${@}"

# check local directories
[ ! -d "$ROOT_DIR/mongo-volume/var/mongo/data" ] && mkdir -p "$ROOT_DIR/mongo-volume/var/mongo/data"
[ ! -d "$ROOT_DIR/mongo-volume/var/mongo/log" ] && mkdir -p "$ROOT_DIR/mongo-volume/var/mongo/log"
[ ! -d "$ROOT_DIR/mongo-volume/var/mongo/run" ] && mkdir -p "$ROOT_DIR/mongo-volume/var/mongo/run"

docker run $_OPTS --name "$CONTAINRER_NAME" -p "$LOCAL_BIND_PORT":27017 \
    --mount type=bind,source="$ROOT_DIR/mongo-volume/etc-mongo",target=/etc/mongo,readonly \
    --mount type=bind,source="$ROOT_DIR/mongo-volume/var/mongo/data",target=/data/db \
    --mount type=bind,source="$ROOT_DIR/mongo-volume/var/mongo",target=/var/mongo \
    -e MONGO_INITDB_ROOT_USERNAME=myroot \
    -e MONGO_INITDB_ROOT_PASSWORD=myroot00 \
    howto:mongo_dev

# N.B.
# the arguments MONGO_INITDB_ROOT_USERNAME and MONGO_INITDB_ROOT_PASSWORD above won't work on mongo 3.x version
# so, you need create the root user manually
# after connecting to the mongo container
#
# $ mongo --verbose mongodb://localhost:17017/admin
# > db.createUser({ user: "myroot", pwd: "myroot00", roles: [ "root" ] })
#

#docker run $_OPTS --name mongo-dev -p 17017:27017 \
#    --mount type=bind,source="$ROOT_DIR/mongo-volume/etc-mongo",target=/etc/mongo,readonly \
#    -e MONGO_INITDB_ROOT_USERNAME=myroot \
#    -e MONGO_INITDB_ROOT_PASSWORD=myroot00 \
#    mongo:4.4.3-bionic

# start interactive bash shell
# docker exec -it mongo-prod bash

#
# verify
#
# mongo --verbose mongodb://myroot:myroot00@localhost:17017/admin
#
