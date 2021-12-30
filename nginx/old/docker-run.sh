#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./docker-run.sh <env> <run_params>'
    echo '  <env>          build environment. *dev|prod'
    echo '  <run_params>   params for docker-run'
    echo '                 dev default: --rm'
    echo '                 prod default: --rm --detach'
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

[ ! -d "$ROOT_DIR/nginx-volume/var/nginx/log" ] && mkdir -p "$ROOT_DIR/nginx-volume/var/nginx/log"
[ ! -d "$ROOT_DIR/nginx-volume/var/nginx/run" ] && mkdir -p "$ROOT_DIR/nginx-volume/var/nginx/run"

if [ "$_ENV" == "dev" ]; then
    if [ "$_OPTS" == "" ]; then
        # run with temp container
        _OPTS="--rm"
    fi
    docker run $_OPTS --name nginx-dev \
        -p 8080:80 \
        --mount type=bind,source="$ROOT_DIR/nginx-volume/etc-nginx",target=/etc/nginx,readonly \
        --mount type=bind,source="$ROOT_DIR/nginx-volume/var/nginx",target=/var/nginx \
        howto:nginx_dev
elif [ "$_ENV" == "prod" ]; then
    if [ "$_OPTS" == "" ]; then
        # --detach: Run container in background and print container ID
        # --rm: run with temp container
        _OPTS="--rm --detach"
    fi
    # stop & remove the container
    # docker container stop nginx-prod
    # docker container rm nginx-prod
    # or
    docker run $_OPTS --name nginx-prod \
        -p 8080:80 \
        --mount type=bind,source="$ROOT_DIR/nginx-volume/etc-nginx",target=/etc/nginx,readonly \
        --mount type=bind,source="$ROOT_DIR/nginx-volume/var/nginx",target=/var/nginx \
        howto:nginx
else
    _usage
    exit 1
fi
