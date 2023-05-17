#!/bin/sh

SCRIPT_PATH=$(dirname $(realpath $0))

BACK_PATH=$(pwd)

cd $SCRIPT_PATH

wget https://services.pages.xaviama.dank-me.me/Workflow/pack.tar.gz -O pack.tar.gz
cd /server/ci

rc-service pipeline stop

rm -rf /server/ci/*

tar -xf $SCRIPT_PATH/pack.tar.gz
rm -f $SCRIPT_PATH/pack.tar.gz

podman build -t ci/pipeline /server/ci

echo $(cat /server/secrets/GamePlayer-8 | head -n 1) | podman login -u GamePlayer-8 --password-stdin forgejo.xaviama.dank-me.me

podman tag ci/pipeline forgejo.xaviama.dank-me.me/services/workflow:latest

podman push forgejo.xaviama.dank-me.me/services/workflow

podman image rm -f ci/pipeline

podman pull forgejo.xaviama.dank-me.me/services/workflow:latest

rc-service pipeline restart

cd $BACK_PATH

