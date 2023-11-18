#!/bin/sh -eu
# vim: set ts=2 sw=2 et:

LOCAL_PROJECT_PATH="${1-$PWD}"

TARGET_ARCH="${2-arm64}"

DOCKER_IMAGE=""

BUILD_COMMAND=" \
  shards build --static --release \
  && chown 1000:1000 -R bin \
  && find bin -type f -maxdepth 1 -exec mv {} {}_${TARGET_ARCH} \; \
"

# crystal
INSTALL_CRYSTAL=" \
  sed -i -e '/^deb/d' /etc/apt/sources.list \
  && sed -i -e '/jessie.updates/d' /etc/apt/sources.list \
  && sed -i -e 's/^# deb/deb/' /etc/apt/sources.list \
  && apt-get update"

cat > /dev/null <<EOF
"
  && apt-get install -y \
    g\+\+ \
    gcc \
    curl \
    autoconf \
    automake \
    python2 \
    libxml2-dev \
    llvm-dev \
    make \
    libssl-dev \
    libpcre2-dev \
    libyaml-dev \
    zlib1g-dev \
"
EOF

# setup arch
case "$TARGET_ARCH" in
  amd64) DOCKER_IMAGE="debian:8" ;;
  arm64) DOCKER_IMAGE="arm64v8/debian:8" ;;
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
  "$DOCKER_IMAGE" \
  /bin/sh -c "$INSTALL_CRYSTAL && bash"

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

