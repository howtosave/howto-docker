#!/bin/bash
#
# run docker image for local development
#

CONTAINRER_NAME=mysql-dev
LOCAL_BIND_PORT=3306

_usage() {
    echo
    echo 'Usage: ./docker-run.sh <run_params>'
    echo '  <run_params>   params for docker-run'
    echo '      --rm       run with temp container(default)'
    echo '      --detach   run in background and print container ID'
    echo
    echo ' to start an interactive shell for the running container'
    echo '    $ docker exec -it mysql-dev bash'
    echo
    echo ' to verify a mysql connection'
    echo '    $ mysql ... --verbose mongodb://myroot:myroot00@localhost:3306/admin'
}

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#
# arguments
#

_OPTS="--rm ${@}"

# check local directories
[ ! -d "$ROOT_DIR/mysql-volume/var/mysql/data" ] && mkdir -p "$ROOT_DIR/mysql-volume/var/mysql/data"
#[ ! -d "$ROOT_DIR/mysql-volume/var/mysql/mysql-files" ] && mkdir -p "$ROOT_DIR/mysql-volume/var/mysql/mysql-files"
#[ ! -d "$ROOT_DIR/mysql-volume/var/mysql/run" ] && mkdir -p "$ROOT_DIR/mysql-volume/var/mysql/run"

docker run $_OPTS --name "$CONTAINRER_NAME" -p "$LOCAL_BIND_PORT":3306 \
    --mount type=bind,source="$ROOT_DIR/mysql-volume/var/mysql/data",target=/var/lib/mysql \
    howto:mysql

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
