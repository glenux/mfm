#!/bin/sh -eu
# vim: set ts=2 sw=2 et:

LOCAL_PROJECT_PATH="${1-$PWD}"

TARGET_ARCH="${2-amd64}"

DOCKER_IMAGE=""

BUILD_COMMAND=" \
  shards build --static --release \
  && chown 1000:1000 -R bin \
  && find bin -type f -maxdepth 1 -exec mv {} {}_${TARGET_ARCH} \; \
"
INSTALL_CRYSTAL=" \
  echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/community' >>/etc/apk/repositories \
  && apk add --update --no-cache --force-overwrite \
    crystal@edge \
    g++ \
    gc-dev \
    libxml2-dev \
    llvm16-dev \
    llvm16-static \
    make \
    musl-dev \
    openssl-dev \
    openssl-libs-static \
    pcre-dev \
    shards@edge \
    yaml-dev \
    yaml-static \
    zlib-dev \
    zlib-static \
"

# setup arch
case "$TARGET_ARCH" in
  amd64) DOCKER_IMAGE="alpine" ;;
  arm64) DOCKER_IMAGE="multiarch/alpine:aarch64-edge" ;;
  armel) DOCKER_IMAGE="multiarch/alpine:armv7-edge" ;;
  # armhf) DOCKER_IMAGE="multiarch/alpine:armhf-edge" ;;
  # i386)  DOCKER_IMAGE="multiarch/alpine:x86-edge" ;;
  mips)  DOCKER_IMAGE="multiarch/alpine:mips-edge" ;;
  mipsel)  DOCKER_IMAGE="multiarch/alpine:mipsel-edge" ;;
  powerpc)  DOCKER_IMAGE="multiarch/alpine:powerpc-edge" ;;
  ppc64el)  DOCKER_IMAGE="multiarch/alpine:ppc64el-edge" ;;
  s390x)  DOCKER_IMAGE="multiarch/alpine:s390x-edge" ;;
esac

# Compile Crystal project statically for target architecture
docker pull multiarch/qemu-user-static:register
docker run \
  --rm \
  --privileged \
  multiarch/qemu-user-static:register \
  --reset
docker run \
  -it \
  -v "$LOCAL_PROJECT_PATH:/app" \
  -w /app \
  --rm \
  "$DOCKER_IMAGE" \
  /bin/sh -c "$INSTALL_CRYSTAL && $BUILD_COMMAND"

