#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./network.sh <env>'
    echo '  <env>          build environment. *dev|prod'
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR
_ENV=${1:-"dev"}

source "$ROOT_DIR/_config.sh"

if [ "$_ENV" == "dev" ]; then
  # check network
  docker network inspect "$NETWORK_NAME" > /dev/null
  if [ "$?" != "0" ]; then
    # create network
    docker network create \
      --driver=bridge \
      --subnet=10.0.0.0/8 \
      --ip-range=10.255.255.255/8 \
      --gateway=10.0.0.1 \
      "$NETWORK_NAME"
  fi
  docker network inspect "$NETWORK_NAME"
elif [ "$_ENV" == "prod" ]; then
  echo "NOOP for production"
else
  _usage
  exit 1
fi
