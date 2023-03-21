#!/bin/sh

$SCRIPT_PATH=$(dirname $(realpath $0))

ls $SCRIPT_PATH
sh $SCRIPT_PATH/src/init.sh

