#!/bin/bash
#
# run docker image for local development
#
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONTAINRER_NAME=mysql-dev
LOCAL_BIND_PORT=3306
MYSQL_ROOT_PASSWORD=root000
DATA_DIR="$ROOT_DIR/volume/mysql/data"

_usage() {
    echo
    echo 'Usage: ./docker-run.sh <run_params>'
    echo '  <run_params>   params for docker-run'
    echo '      --rm            run with temp container(default)'
    echo '      --detach(-d)    run in background'
    echo
    echo ' to start an interactive shell for the running container'
    echo '    $ docker exec -it mysql-dev bash'
    echo
    echo ' to verify a mysql connection'
    echo '    $ mysql -uroot -proot000 -h localhost'
}

#
# arguments
#

_OPTS="--rm ${@}"

# create directories
mkdir -p $DATA_DIR

docker run $_OPTS --name "$CONTAINRER_NAME" \
    --publish "$LOCAL_BIND_PORT":3306 \
    --volume $DATA_DIR:/var/lib/mysql \
    --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    mysql:8.0

#
# verify
#
# docker exec -it mysql-dev mysql -uroot -proot000 -e "show databases;" && echo "ok" || echo "failed"
#
