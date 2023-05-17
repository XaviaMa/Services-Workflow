#!/bin/sh

export pipe=/tmp/pipe

function shutdown() {
    rm -f $pipe
    echo Master shutdown!
    exit 0
}

trap "shutdown" SIGINT SIGTERM
trap "shutdown" ERR

rm -rf /ci/shared/*
podman system migrate
podman container prune -f
podman build -t ci/container /ci/container
if ! [ -f /encrypt.key ]; then
    openssl genrsa -out /encrypt.key 4096
fi
if ! [ -f /encrypt.crt ]; then
    openssl req -new -x509 -key /encrypt.key -subj "/C=PL/O=Workflow/OU=Workflow/CN=domain.local" \
     -nodes -sha256 -out /encrypt.crt
fi
sh /ci/listener.sh 8080 /ci/builder.sh
