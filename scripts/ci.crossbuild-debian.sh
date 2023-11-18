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

# crystal
INSTALL_CRYSTAL=" \
  sed -i -e 's/Types: deb/Types: deb deb-src/' /etc/apt/sources.list.d/debian.sources \
  && echo 'deb http://deb.debian.org/debian unstable main' > /etc/apt/sources.list.d/sid.list \
  && echo 'deb-src http://deb.debian.org/debian unstable main' >> /etc/apt/sources.list.d/sid.list \
  && apt-get update \
  && apt-get install -y \
    g++ \
    libxml2-dev \
    llvm-dev \
    make \
    libssl-dev \
    libpcre3-dev \
    libyaml-dev \
    zlib1g-dev \
    dpkg-dev \
    debuild \
  && apt source crystal \
  && apt build-dep crystal \
  && ls -lF \
  && debuild -b -uc -us \
"

# setup arch
case "$TARGET_ARCH" in
  amd64) DOCKER_IMAGE="debian" ;;
  arm64) DOCKER_IMAGE="arm64v8/debian" ;;
  armel) DOCKER_IMAGE="arm32v7/debian" ;;
  armhf) DOCKER_IMAGE="armhf/debian" ;;
  i386)  DOCKER_IMAGE="x86/debian" ;;
  mips)  DOCKER_IMAGE="mips/debian" ;;
  mipsel)  DOCKER_IMAGE="mipsel/debian" ;;
  powerpc)  DOCKER_IMAGE="powerpc/debian" ;;
  ppc64el)  DOCKER_IMAGE="ppc64el/debian" ;;
  s390x)  DOCKER_IMAGE="s390x/debian" ;;
esac

# Compile Crystal project statically for target architecture
docker pull multiarch/qemu-user-static

docker run \
  --rm \
  --privileged \
  multiarch/qemu-user-static \
  --reset -p yes

set -x
docker run \
  -it \
  -v "$LOCAL_PROJECT_PATH:/app" \
  -w /app \
  --rm \
  --platform linux/arm64 \
  "$DOCKER_IMAGE"

exit 0

set -x
docker run \
  -it \
  -v "$LOCAL_PROJECT_PATH:/app" \
  -w /app \
  --rm \
  --platform linux/arm64 \
  "$DOCKER_IMAGE" \
  /bin/sh -c "$INSTALL_CRYSTAL && $BUILD_COMMAND"

