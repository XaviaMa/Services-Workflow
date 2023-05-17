#!/bin/sh

SCRIPT_PATH=$(dirname $(realpath $0))

function shutdown() {
        rm -f $pipe;
        echo "Shutdown!"
        exit 0
}

trap "shutdown" SIGINT SIGTERM

[[ -e $pipe ]] || mkfifo $pipe;

while [ 1 ]; do
        nc -c -l -t -p $1 0<$pipe | $SCRIPT_PATH/handler.sh $2 1>$pipe;
done
