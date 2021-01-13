#!/bin/bash
_usage() {
  echo
  echo 'Usage: ./docker-build.sh <env>'
  echo '  <env>          build environment. *dev|prod'
  echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR
_ENV=${1:-"dev"}

if [ "$_ENV" == "dev" ]; then
  echo
  echo ">>> Build image for development mode"
  echo
  docker build --file "$ROOT_DIR/dockerfile.dev" \
    --tag howto:nginx_dev \
    --build-arg etc_nginx=/etc/nginx \
    --build-arg var_nginx=/var/nginx \
    "$ROOT_DIR"
elif [ "$_ENV" == "prod" ]; then
  echo
  echo ">>> Build image for production mode"
  echo
  docker build --file "$ROOT_DIR/dockerfile" \
    --tag howto:nginx \
    --build-arg etc_nginx=/etc/nginx \
    --build-arg var_nginx=/var/nginx \
    --build-arg volume_rw=/volume-rw \
    "$ROOT_DIR"
else
  _usage
  exit 1
fi
