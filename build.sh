#!/bin/sh

SCRIPT_PATH=$(dirname $(realpath $0))

BACK_PATH=$(pwd)

cd $SCRIPT_PATH/src/pipeline

podman build -t ci/pipeline .

if [ $1 == 1 ]; then
    cd ../container
    podman build -t ci/container .
fi

cd $BACK_PATH
