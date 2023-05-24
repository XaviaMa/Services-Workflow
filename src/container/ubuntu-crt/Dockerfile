FROM ubuntu

USER root

# PATCH PROXY CERTIFICATES

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Warsaw

RUN apt update && \
    apt upgrade --yes && \
    apt install --yes wget openssl git curl apt-utils dialog && \
    apt clean && \
    apt autoremove --yes

RUN wget http://proxify.xaviama.dank-me.me/browser.pem && \
    cat browser.pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.pem && \
    rm -f /etc/ssl/cert.pem && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem && \
    mkdir -p /etc/ssl1.1 || true && \
    ln -s /etc/ssl/cert.pem /etc/ssl1.1/cert.pem

COPY runner.sh /usr/bin/runner

RUN chmod +x /usr/bin/runner

RUN wget http://proxify.xaviama.dank-me.me/browser.pem && \
    cat browser.pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.pem && \
    rm -f /etc/ssl/cert.pem && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem && \
    mkdir -p /etc/ssl1.1 || true && \
    ln -s /etc/ssl/cert.pem /etc/ssl1.1/cert.pem
