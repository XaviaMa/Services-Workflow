FROM alpine

USER root

# PATCH PROXY CERTIFICATES

RUN wget http://proxify.xaviama.dank-me.me/browser.pem && \
    cat browser.pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.pem && \
    rm -f /etc/ssl/cert.pem && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem && \
    mkdir -p /etc/ssl1.1 || true && \
    ln -s /etc/ssl/cert.pem /etc/ssl1.1/cert.pem

RUN apk add --no-cache git curl coreutils ca-certificates openssl podman

COPY runner.sh /usr/bin/runner

RUN chmod +x /usr/bin/runner

COPY pipeline/containers.conf /etc/containers/containers.conf
COPY pipeline/podman-containers.conf /home/podman/.config/containers/containers.conf
RUN chmod 644 /etc/containers/containers.conf && \
    sed -i -e 's|^#mount_program|mount_program|g' -e \
    '/additionalimage.*/a "/var/lib/shared",' -e \
    's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
    /etc/containers/storage.conf && \
    mkdir -p /var/lib/shared/overlay-images \
    /var/lib/shared/overlay-layers /var/lib/shared/vfs-images \
    /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock && \
    mkdir /listen

ENV _CONTAINERS_USERNS_CONFIGURED=""

RUN podman system migrate

RUN wget http://proxify.xaviama.dank-me.me/browser.pem && \
    cat browser.pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.pem && \
    rm -f /etc/ssl/cert.pem && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem && \
    mkdir -p /etc/ssl1.1 || true && \
    ln -s /etc/ssl/cert.pem /etc/ssl1.1/cert.pem
