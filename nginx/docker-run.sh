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

[ ! -d "$ROOT_DIR/nginx-volume/log/nginx" ] && mkdir -p "$ROOT_DIR/nginx-volume/log/nginx"
[ ! -d "$ROOT_DIR/nginx-volume/run/nginx" ] && mkdir -p "$ROOT_DIR/nginx-volume/run/nginx"

if [ "$_ENV" == "dev" ]; then
    # run with temp container
    docker run --rm -it --name nginx-dev -p 8080:80 \
        --mount type=bind,source="$ROOT_DIR/nginx-volume",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/nginx-volume",target=/volume-rw \
        howto:nginx_dev
elif [ "$_ENV" == "prod" ]; then
    # or
    docker run --rm -it --name nginx-prod -p 8080:80 \
        --mount type=bind,source="$ROOT_DIR/nginx-volume",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/nginx-volume",target=/volume-rw \
        howto:nginx
else
    _usage
    exit 1
fi
