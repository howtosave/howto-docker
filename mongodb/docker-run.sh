#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./docker-run.sh <env>'
    echo '  <env>          build environment. *dev|prod'
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR
_ENV=${1:-"dev"}

[ ! -d "$ROOT_DIR/mongo-volume/mongo-data" ] && mkdir -p "$ROOT_DIR/mongo-volume/mongo-data"
[ ! -d "$ROOT_DIR/mongo-volume/log/mongodb" ] && mkdir -p "$ROOT_DIR/mongo-volume/log/mongodb"
[ ! -d "$ROOT_DIR/mongo-volume/run/mongodb" ] && mkdir -p "$ROOT_DIR/mongo-volume/run/mongodb"

if [ "$_ENV" == "dev" ]; then
    # run with temp container
    docker run --rm -it --name mongo-dev -p 27017:27017 \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/mongo-conf",target=/etc/mongo,readonly \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/mongo-data",target=/data/db \
        howto:mongo_dev
elif [ "$_ENV" == "prod" ]; then
    docker run --rm -it --name mongo-prod -p 27017:27017 \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/mongo-conf",target=/etc/mongo,readonly \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/mongo-data",target=/data/db \
        howto:mongo bash
elif [ "$_ENV" == "prod_d" ]; then
    docker run -d --name mongo-prod -p 27017:27017 \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/mongo-conf",target=/etc/mongo,readonly \
        --mount type=bind,source="$ROOT_DIR/mongo-volume/mongo-data",target=/data/db \
        howto:mongo bash
elif [ "$_ENV" == "sh_prod" ]; then
    # start interactive bash shell
    docker exec -it mongo-prod bash
else
    _usage
    exit 1
fi
