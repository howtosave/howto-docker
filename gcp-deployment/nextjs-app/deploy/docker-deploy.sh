#!/bin/bash

#
# docker deployment scripts
#
_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CMD=$1
VOLUME_DIR=${2:-${_DIR}/volume}

echo "$CMD to $VOLUME_DIR"

function update {
    local dest="$1"
    cp -r ./public/* $VOLUME_DIR/nginx/readonly/c.com/html
}

if [ "$CMD" == "setup" ]; then
    # rw, ro dir
    mkdir -p $VOLUME_DIR/nextjs/{readwrite,readonly}
    # log dir
    mkdir -p $VOLUME_DIR/nextjs/readwrite/log
    # html dir
    mkdir -p $VOLUME_DIR/nginx/readonly/c.com/html

    update
elif [ "$CMD" == "update" ]; then
    update
else
    echo "!!! unsupported command: $CMD"
fi
