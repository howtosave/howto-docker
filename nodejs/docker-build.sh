#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./docker-build.sh <env>'
    echo '  <env>          build environment. *dev|prod'
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR/app
_ENV=${1:-"dev"}

echo
echo ">>> Build image for $_ENV mode"
echo
if [ "$_ENV" == "dev" ]; then
    docker build --file "$ROOT_DIR/dockerfile.pm2.dev" \
        --tag howto:pm2_dev \
        --build-arg volume_ro=/volume-ro \
        --build-arg volume_rw=/volume-rw \
        "$ROOT_DIR"
elif [ "$_ENV" == "prod" ]; then
    docker build --file "$ROOT_DIR/dockerfile.pm2" \
        --tag howto:pm2 \
        --build-arg volume_ro=/volume-ro \
        --build-arg volume_rw=/volume-rw \
        "$ROOT_DIR"
else
    _usage
    exit 1
fi
