#!/bin/sh

export pipe=/tmp/pipe

function shutdown() {
    rm -f $pipe
    echo Master shutdown!
    exit 0
}

trap "shutdown" SIGINT SIGTERM

rm -rf /ci/shared/*
podman system migrate
podman container prune -f
podman build -t ci/container /ci/container
sh /ci/listener.sh 8080 /ci/builder.sh
