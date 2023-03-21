#!/bin/sh

export URL=$1
export COMMIT=$2
export COMMITTER=$3
export OWNER=$4
export DOMAIN=$5
SECRET=$(cat /runner/secret)

mkdir /source
cd /source

git config --global advice.detachedHead false
git config --global init.defaultBranch main

git init > /dev/null
git remote add origin $URL
echo 'https://'$COMMITTER:$SECRET@$DOMAIN > ~/.git-credentials
git fetch origin $COMMIT
git checkout $COMMIT

if ! [ -f /source/init.sh ]; then
    echo "Init script 'init.sh' was not found. Exiting with code 1."
    exit 1
fi

sh /source/init.sh
