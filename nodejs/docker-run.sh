#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./docker-run.sh <env> <run_params>'
    echo '  <env>          build environment. *dev|prod'
    echo '  <run_params>   params for docker-run'
    echo '                 dev default: --rm -it -p 8080:80'
    echo '                 prod default: --rm -it -p 8080:80'
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR/app
#
# arguments
#
_ENV=${1:-"dev"}
shift 1
_OPTS=${@}

[ ! -d "$ROOT_DIR/app-volume/app/public" ] && mkdir -p "$ROOT_DIR/app-volume/app/public"
[ ! -d "$ROOT_DIR/app-volume/var/app/log" ] && mkdir -p "$ROOT_DIR/app-volume/var/app/log"
[ ! -d "$ROOT_DIR/app-volume/var/app/upload" ] && mkdir -p "$ROOT_DIR/app-volume/var/app/upload"

if [ "$_ENV" == "dev" ]; then
    # run with temp container
    docker run --rm -it --name howto-pm2-dev \
        -e PORT=2337 --expose 2337 -p 2337:2337 \
        --mount type=bind,source="$ROOT_DIR/app-volume/app",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/app-volume/var/app",target=/volume-rw \
        --mount type=bind,source="$ROOT_DIR",target=/workdir \
        -e NODE_ENV=development \
        howto:pm2_dev
elif [ "$_ENV" == "prod" ]; then
    docker run --rm -it --name howto-pm2 \
        -e PORT=2337 --expose 2337 -p 2337:2337 \
        --mount type=bind,source="$ROOT_DIR/app-volume/app",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/app-volume/var/app",target=/volume-rw \
        -e NODE_ENV=production \
        howto:pm2
else
    _usage
    exit 1
fi

#
# verify
#
# curl http://localhost:2337
# curl http://localhost:2337/upload/msg1

