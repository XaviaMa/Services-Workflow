#!/bin/sh

SCRIPT_PATH=$(dirname $(realpath $0))
LOG_PATH=/ci/request.log

trap "echo Shutdown!; exit 0" SIGINT SIGTERM

while inotifywait -q -e modify $LOG_PATH; do
        sh $SCRIPT_PATH/builder.sh $(X=$(wc -l $LOG_PATH | cut -f 1 -d " "); let "X=X+1"; echo $X) &
done