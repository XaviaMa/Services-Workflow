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
        ncat --ssl --ssl-key /encrypt.key --ssl-cert /encrypt.crt --idle-timeout 0.1 -l -p $1 0<$pipe 2>/dev/null 3>&2 | $SCRIPT_PATH/handler.sh $2 1>$pipe;
done
