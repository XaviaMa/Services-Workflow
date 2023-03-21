FROM alpine

USER root

# PATCH PROXY CERTIFICATES

RUN wget http://proxify.xaviama.dank-me.me/browser.der && \
    sed -i 's/https\:\/\/dl-cdn.alpinelinux.org/http\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories && \
    apk add --no-cache openssl && \
    openssl x509 -inform der -in browser.der -outform pem >> /etc/ssl/certs/ca-certificates.crt && \
    rm -f browser.der && \
    sed -i 's/http/https/g' /etc/apk/repositories

COPY init.sh /usr/bin/podinit
RUN chmod +x /usr/bin/podinit

RUN apk add --no-cache podman fuse-overlayfs && \
    apk add --no-cache inotify-tools coreutils

VOLUME /var/lib/containers
VOLUME /home/podman/.local/share/containers

COPY containers.conf /etc/containers/containers.conf
COPY podman-containers.conf /home/podman/.config/containers/containers.conf

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

CMD ["podinit"]
