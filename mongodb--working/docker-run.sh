#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./docker-run.sh <env> <run_params>'
    echo '  <env>          build environment. *dev|prod'
    echo '  <run_params>   params for docker-run'
    echo '                 dev default: --rm '
    echo '                 prod default: --rm '
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR
#
# arguments
#
_ENV=${1:-"dev"}
shift 1
_OPTS=${@}

[ ! -d "$ROOT_DIR/mongo-volume/var/mongo/data" ] && mkdir -p "$ROOT_DIR/mongo-volume/var/mongo/data"
[ ! -d "$ROOT_DIR/mongo-volume/var/mongo/log" ] && mkdir -p "$ROOT_DIR/mongo-volume/var/mongo/log"
[ ! -d "$ROOT_DIR/mongo-volume/var/mongo/run" ] && mkdir -p "$ROOT_DIR/mongo-volume/var/mongo/run"

if [ "$_ENV" == "dev" ]; then
    if [ "$_OPTS" == "" ]; then
        # run with temp container
        _OPTS="--rm"
    fi
    docker run $_OPTS --name mongo-dev -p 17017:27017 \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/var/mongo/data",target=/data/db \
        -e MONGO_INITDB_ROOT_USERNAME=myroot \
        -e MONGO_INITDB_ROOT_PASSWORD=myroot00 \
        mongo:4.4.3-bionic

    #docker run $_OPTS --name mongo-dev -p 17017:27017 \
    #    --mount type=bind,source="$ROOT_DIR/mongo-volume/etc-mongo",target=/etc/mongo,readonly \
    #    --mount type=bind,source="$ROOT_DIR/mongo-volume/var/mongo",target=/var/mongo \
    #    howto:mongo_dev
    # --entrypoint "cat /etc/mongod.conf" 
elif [ "$_ENV" == "prod" ]; then
    if [ "$_OPTS" == "" ]; then
        # --detach: Run container in background and print container ID
        # --rm: run with temp container
        _OPTS="--rm --detach"
    fi
    docker run $_OPTS --name mongo-prod -p 17017:27017 \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/etc-mongo",target=/etc/mongo,readonly \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/var/mongo",target=/var/mongo \
        howto:mongo
elif [ "$_ENV" == "sh_prod" ]; then
    # start interactive bash shell
    docker exec -it mongo-prod bash
else
    _usage
    exit 1
fi

#
# verify
#
# mongo --verbose mongodb://myroot:myroot00@localhost:17017/admin
#
