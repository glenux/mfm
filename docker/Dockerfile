FROM debian:trixie

RUN set -ex \
    && sed -i \
    	-e 's/Types: deb/Types: deb deb-src/g' \
    	/etc/apt/sources.list.d/debian.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
               build-essential \
               cdbs \
               devscripts \
               equivs \
               fakeroot \
               crystal \
               shards \
               git-buildpackage \
               libyaml-dev \
               libxml2-dev \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*

WORKDIR /app
