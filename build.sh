#!/bin/sh

# References:
# - https://www.debian.org/doc/manuals/maint-guide/build.en.html for base principles
# - https://www.patreon.com/posts/building-debian-23177439 for debuild output dir
#
set -ue

mkdir -p _build || true

docker build -t debbuilder --file docker/Dockerfile . 
docker run -it -v "$(pwd):/app" -v "$(pwd)/_build:/_build" debbuilder \
	sh -c "ARTIFACTS_DIR=/app/_build debuild --preserve-envvar=ARTIFACTS_DIR -us -uc --buildinfo-option=-u/app/_build --changes-option=-u/app/_build" \
	|| docker run -it -v "$(pwd):/app" debbuilder 

# dpkg-buildpackage -us -uc
# debuild
# git-buildpackage
echo SUCCESS
