ARG VERSION=2024091700

FROM alpine:latest

LABEL maintainer="Thien Tran contact@tommytran.io"

ARG VERSION
ARG CONFIG_NATIVE=false
ARG VARIANT=default

RUN apk -U upgrade \
    && apk --no-cache add build-base git gnupg openssh-keygen \
    && rm -rf /var/cache/apk/*
    
RUN cd /tmp \
    && git clone --depth 1 --branch ${VERSION} https://github.com/GrapheneOS/hardened_malloc \
    && cd hardened_malloc \
    && wget -q https://grapheneos.org/allowed_signers -O grapheneos_allowed_signers

RUN --network=none cd /tmp/hardened_malloc \
    && git config gpg.ssh.allowedSignersFile grapheneos_allowed_signers \
    && git verify-tag $(git describe --tags) \
    && make CONFIG_NATIVE=${CONFIG_NATIVE} VARIANT=${VARIANT} \
    && mkdir -p /install \
    && mv /tmp/hardened_malloc/out/libhardened_malloc.so /install
