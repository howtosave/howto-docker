#!/bin/bash

#
# docker deployment scripts
#
_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CMD=$1
VOLUME_DIR=${2:-./volume}

echo "$CMD to $VOLUME_DIR"

if [ "$CMD" == "setup" ]; then
    echo "nothing to do"
elif [ "$CMD" == "update" ]; then
    echo "nothing to do"
else
    echo "!!! unsupported command: $CMD"
fi
