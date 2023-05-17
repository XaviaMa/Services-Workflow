#!/bin/sh

apk add --no-cache markdown tar

echo '<!DOCTYPE html>' > index.html
echo '<html lang="en-US">' >> index.html
cat docs/head.html >> index.html

echo '<body>' >> index.html
echo '<div>' >> index.html
markdown README.md >> index.html
echo '</div>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html

BACK_PATH=$(pwd)

mkdir -v /runner/page/
cp -rv /source/src/* /runner/page/
cd /runner/page
tar -czvf pack.tar.gz *

cd $BACK_PATH

mv docs /runner/page/

mv index.html /runner/page/
