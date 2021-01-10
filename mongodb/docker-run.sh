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

if [ "$_ENV" == "dev" ]; then
    # run with temp container
    docker run --rm -it --name mongo-dev -p 27017:27017 \
        --mount type=bind,source="$ROOT_DIR/mongo-volume",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/mongo-volume",target=/volume-rw \
        howto:mongo_dev
elif [ "$_ENV" == "prod" ]; then
    docker run --rm -it --name mongo-prod -p 27017:27017 \
        --mount type=bind,source="$ROOT_DIR/mongo-volume",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/mongo-volume",target=/volume-rw \
        howto:mongo
else
    _usage
    exit 1
fi
