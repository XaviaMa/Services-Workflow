#!/bin/sh

clen=

# read http payload
read -r -t 10 -n $clen payload

echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nOK\r\n\r\n"

if [ -f "$1" ]; then
    sh "$1" "$payload" >/dev/null 2>&1 3>&1 &
fi
