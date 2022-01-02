#!/bin/bash

#
# docker deployment scripts
#
_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CMD=$1
VOLUME_DIR=${2:-./volume}

echo "$CMD to $VOLUME_DIR"

function update {
    local dest="$1"
    cp -r ./config/mysql/* $VOLUME_DIR/mysql/config
}

if [ "$CMD" == "setup" ]; then
    mkdir -p $VOLUME_DIR/mysql/{config,readonly,readwrite}
    update
elif [ "$CMD" == "update" ]; then
    update
else
    echo "!!! unsupported command: $CMD"
fi
