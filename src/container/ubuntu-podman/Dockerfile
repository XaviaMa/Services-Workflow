FROM ubuntu

USER root

# PATCH PROXY CERTIFICATES

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Warsaw

RUN apt update && \
    apt upgrade --yes && \
    apt install --yes wget openssl git curl apt-utils dialog podman && \
    apt clean && \
    apt autoremove --yes

RUN wget http://proxify.xaviama.dank-me.me/browser.pem && \
    cat browser.pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.pem && \
    rm -f /etc/ssl/cert.pem && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem && \
    mkdir -p /etc/ssl1.1 || true && \
    ln -s /etc/ssl/cert.pem /etc/ssl1.1/cert.pem

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

COPY runner.sh /usr/bin/runner

RUN chmod +x /usr/bin/runner

RUN wget http://proxify.xaviama.dank-me.me/browser.pem && \
    cat browser.pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.pem && \
    rm -f /etc/ssl/cert.pem && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem && \
    mkdir -p /etc/ssl1.1 || true && \
    ln -s /etc/ssl/cert.pem /etc/ssl1.1/cert.pem
