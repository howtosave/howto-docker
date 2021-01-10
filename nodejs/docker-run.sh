#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./docker-run.sh <env>'
    echo '  <env>          build environment. *dev|prod'
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR/app

_ENV=${1:-"dev"}
if [[ "$_ENV" != "dev" && "$_ENV" != "prod" ]]; then
    _usage
    exit 1
fi

if [ "$_ENV" == "dev" ]; then
    # run with temp container
    docker run --rm -it --name howto-pm2-dev \
        -e PORT=2337 --expose 2337 -p 2337:2337 \
        --mount type=bind,source="$ROOT_DIR/app-volume",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/app-volume",target=/volume-rw \
        --mount type=bind,source="$ROOT_DIR",target=/workdir \
        -e NODE_ENV=development \
        howto:pm2_dev
elif [ "$_ENV" == "prod" ]; then
    docker run --rm -it --name howto-pm2 \
        -e PORT=2337 --expose 2337 -p 2337:2337 \
        --mount type=bind,source="$ROOT_DIR/app-volume",target=/volume-ro,readonly \
        --mount type=bind,source="$ROOT_DIR/app-volume",target=/volume-rw \
        -e NODE_ENV=production \
        howto:pm2
else
    _usage
    exit 1
fi
