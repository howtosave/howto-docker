#!/bin/bash
_usage() {
    echo
    echo 'Usage: ./volume.sh <env>'
    echo '  <env>          build environment. *dev|prod'
    echo
}

_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR=$_SCRIPT_DIR
_ENV=${1:-"dev"}

source "$ROOT_DIR/_config.sh"

if [ "$_ENV" == "dev" ]; then
  # check volumes
  docker run --rm -it --name volume-dev -p 8080:80 --network "$NETWORK_NAME" \
      --mount type=bind,source="$ROOT_DIR/docker-volumes",target=/volume \
      --entrypoint /bin/bash --user node --workdir /home/node \
      node:10.23.1-stretch

      #--mount type=bind,source="$ROOT_DIR/docker-volumes/ro",target=/volume-ro,readonly \
      #--mount type=bind,source="$ROOT_DIR/docker-volumes/rw",target=/volume-rw \

  # run the following command on the terminal to copy files under host to the docker container
  # rm -rf /volume/ro/etc-nginx
  # scp -r peterk@10.0.0.1:~/Workspace/carbon/howto-docker/nginx/nginx-volume/etc-nginx /volume/ro
  # rm -rf /volume/ro/etc-mongo
  # scp -r peterk@10.0.0.1:~/Workspace/carbon/howto-docker/mongodb/mongo-volume/etc-mongo /volume/ro
  # mkdir -p /volume/rw/var/log /volume/rw/var/run /volume/rw/var/mongo-data
elif [ "$_ENV" == "prod" ]; then
  echo "NOOP for production"
else
  _usage
  exit 1
fi
