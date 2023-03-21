#!/bin/sh

trap "echo Master shutdown!; exit" SIGINT SIGTERM

rm -rf /ci/shared/*
podman system migrate
podman container prune -f
podman build -t ci/container /ci/container
podman system service -t 0 unix:///listen/podman.sock &
sh /ci/queue.sh