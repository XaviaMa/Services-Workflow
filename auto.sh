#!/bin/sh

INSTALL_PATH=/server/ci

SCRIPT_PATH=$(dirname $(realpath $0))
BACK_PATH=$(pwd)

cd $SCRIPT_PATH

sh build.sh $*

if [ -z $2 ]; then
        INSTALL_PATH=$2
fi

if [ -d /etc/init.d ]; then
        cp $SCRIPT_PATH/src/openrc /etc/init.d/pipeline
        cp $SCRIPT_PATH/src/openrc.conf /etc/conf.d/pipeline
        chmod +x /etc/init.d/pipeline
fi

cp -r src/* $INSTALL_PATH/

cd $BACK_PATH
