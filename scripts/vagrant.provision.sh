#!/bin/sh

# install crystal
set -e
set -u

USER="$(test -d /vagrant && echo "vagrant" || echo "debian")"
HOSTNAME="$(hostname)"

export DEBIAN_FRONTEND=noninteractive

echo "Installing required system packages"
apt-get update --allow-releaseinfo-change
apt-get install -y \
   apt-transport-https \
   ca-certificates \
   git \
   curl \
   wget \
   vim \
   gnupg2 \
   software-properties-common

echo "Installing recording requirements"
apt-get install -y \
   tmux \
   mdp \
   bat \
   asciinema \
   termtosvg

echo "Installing mfm requirements"
apt-get install -y \
   fzf \
   sshfs \
   httpdirfs \
   libyaml-0-2 \
   libyaml-dev \
   libpcre3-dev \
   libevent-dev

#!/bin/sh

set -e
set -u

USER="$(test -d /vagrant && echo "vagrant" || echo "debian")"
CLUSTERS_DIR=/home/$USER/clusters

# Installation de kompose
if [ ! -f /usr/local/bin/kompose ]; then
	DL="$(mktemp)"
	curl \
		-L https://github.com/kubernetes/kompose/releases/download/v1.22.0/kompose-linux-amd64 \
		-o "$DL"
	chmod +x "$DL"
	mv "$DL" /usr/local/bin/kompose
fi

# Installing asdf
su - "$USER" -c "git config --global advice.detachedHead false"
su - "$USER" -c "rm -rf ~/.asdf"
su - "$USER" -c "git clone --quiet https://github.com/asdf-vm/asdf.git \
					~/.asdf \
					--branch v0.8.0"
su - "$USER" -c "echo '. \$HOME/.asdf/asdf.sh' >> ~/.bashrc"

su - "$USER" -c "source \$HOME/.asdf/asdf.sh \
				 && asdf plugin add crystal 2>&1 \
				 && asdf install crystal 1.7.3 >/dev/null 2>&1 \
 				 && asdf global  crystal 1.7.3"

