FROM alpine

USER root

# PATCH PROXY CERTIFICATES

RUN wget http://proxify.xaviama.dank-me.me/browser.der && \
    sed -i 's/https\:\/\/dl-cdn.alpinelinux.org/http\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories && \
    apk add --no-cache openssl && \
    openssl x509 -inform der -in browser.der -outform pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.der && \
    sed -i 's/http/https/g' /etc/apk/repositories

COPY runner /usr/bin/

RUN chmod +x /usr/bin/runner

RUN apk add --no-cache git curl coreutils

RUN wget http://proxify.xaviama.dank-me.me/browser.der && \
    openssl x509 -inform der -in browser.der -outform pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.der
