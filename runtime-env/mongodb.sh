#!/bin/bash
_usage() {
  echo
  echo 'Usage: ./mongodb.sh <env> <run_params>'
  echo '  <env>          build environment. *dev|prod'
  echo '  <run_params>   params for docker-run'
  echo '                 dev default: --rm '
  echo '                 prod default: --rm '
  echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR

#
# load config
#
source "$ROOT_DIR/_config.sh"

#
# arguments
#
_ENV=${1:-"dev"}
shift 1
_OPTS=${@}

[ ! -d "$ROOT_DIR/docker-volumes/var/mongo/data" ] && mkdir -p "$ROOT_DIR/docker-volumes/var/mongo/data"

if [ "$_ENV" == "dev" ]; then
  if [ "$_OPTS" == "" ]; then
    # --rm: run with temp container
    # --detach
    _OPTS="--rm --detach"
  fi
  docker run $_OPTS --name mongo-dev -p 27017:27017 --network "$NETWORK_NAME" \
    --mount type=bind,source="$ROOT_DIR/docker-volumes/var/mongo/data",target=/data/db \
    -e MONGO_INITDB_ROOT_USERNAME=myroot \
    -e MONGO_INITDB_ROOT_PASSWORD=myroot00 \
    mongo:4.2.11-bionic
  # mongo:4.4.3-bionic 4.2.11-bionic 4.0.22-xenial
elif [ "$_ENV" == "prod" ]; then
  echo "NOOP for production"
elif [ "$_ENV" == "attach" ]; then
  # start interactive bash shell
  docker exec -it mongo-dev bash
elif [ "$_ENV" == "stop" ]; then
  # start interactive bash shell
  docker container stop mongo-dev
else
  _usage
  exit 1
fi

#
# verify
#
# mongo --verbose mongodb://myroot:myroot00@localhost:17017/admin
#
