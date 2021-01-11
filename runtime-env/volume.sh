#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./volume.sh <env>'
    echo '  <env>          build environment. *dev|prod'
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR/app

VOLUME_TYPE="bind" # local
VOLUME_NAME="howto_volume"
VOLUME_RO_NAME="howto_ro_volume"

_create_bind_volume() {
  local name="$1"
  docker volume create \
    --driver=bridge \
    --subnet=10.0.0.0/8 \
    --ip-range=10.255.255.255/8 \
    --gateway=10.0.0.1 \
    "$name"

}

_ensure_volume() {
  local name="$1"
  # check network
  docker volume inspect "$name" > /dev/null
  if [ "$?" != "0" ]; then
    # create network
    docker volume create \
      --driver=bridge \
      --subnet=10.0.0.0/8 \
      --ip-range=10.255.255.255/8 \
      --gateway=10.0.0.1 \
      "$name"
  fi
}

if [ "$_ENV" == "dev" ]; then
  # check volumes
  _ensure_volume "$VOLUME_NAME"
  _ensure_volume "$VOLUME_RO_NAME"

  docker volume inspect "$VOLUME_NAME"
  docker volume inspect "$VOLUME_RO_NAME"
elif [ "$_ENV" == "prod" ]; then
  echo "NOOP for production"
else
  _usage
  exit 1
fi
