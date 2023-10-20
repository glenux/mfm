#!/bin/sh
# vim: set ft=sh :

set -e
set -u

CONFIG_FILE="$HOME/.config/gx-vault.yml"
MNTDIR="$HOME/mnt"

gxvault_gocryptfs_is_mounted() {
	src="$1"

	if LANG=C mount |grep -q "^$src on " ; then
		# >&2 echo "W: $src is already mounted"
		return 0
	fi
	return 1
}

gxvault_gocryptfs_mount() {
	name="$1"
	src="$2"
	dst="$3"
	mkdir -p "$dst"

	if [ ! -e "$src" ]; then
		printf '\033[31m-> Missing input directory. Skipping.\033[0m\n'
		return
	fi
	if LANG=C mount |grep -q "$src on $dst" ; then
		printf '\033[33m-> Already mounted. Skipping.\033[0m\n'
		return
	fi
	gocryptfs -idle 15m "$src" "$dst"
	printf '\033[32mVault %s is now available on %s\033[0m\n' "$name" "$(echo "$dst" |sed -e "s|^$HOME|~|")"
}

# Ensure that yq is installed with the right version
gxvault_ensure_dependency_yq() {
	if ! hash yq >/dev/null 2>&1 ; then
  	  >&2 echo "ERROR: unable to find yq (yaml util)"
  	  exit 1
	fi

	YQ_VERSION="$(yq --version |sed 's/.*version //' |cut -d '.' -f1 |sed -e 's/^v//' )"
	if [ "$YQ_VERSION" -lt 4 ]; then
  	  >&2 echo "ERROR: installed version of yq is too old (found $YQ_VERSION instead of 4+)"
  	  exit 1
	fi
}

# Ensure that all dependencies are installed
gxvault_ensure_dependency_yq


# Get list of sources
SRC_LIST="$(mktemp)"
SRC_COUNT="$(yq eval '.vaults[].name' "$CONFIG_FILE" |wc -l )"

{
	for INDEX1 in $(seq 1 "$SRC_COUNT") ; do
		INDEX0=$((INDEX1 - 1))
		CUR_NAME="$(yq eval ".vaults[$INDEX0].name" "$CONFIG_FILE")"
		CUR_DIR="$(yq eval ".vaults[$INDEX0].encrypted_path" "$CONFIG_FILE")"
		if gxvault_gocryptfs_is_mounted "$CUR_DIR" ; then
			printf "%s\v [\e[32mopen\e[0m]\n" "$CUR_NAME"
		else
			echo "$CUR_NAME"
		fi
	done
} | sort > "$SRC_LIST"

# cat "$SRC_LIST"
SRC_NAME="$(fzf --ansi < "$SRC_LIST")"
# echo "fzf: $SRC_NAME"
SRC_NAME="$(echo "$SRC_NAME" |sed -e "s/\v.*//")"
# echo "sed: $SRC_NAME"
rm -f "$SRC_LIST"

if [ -z "$SRC_NAME" ]; then
	echo "All vaults already mounted or no vaults defined"
	exit 0
fi

SRC_DIR="$(yq eval ".vaults[] | select(.name == \"$SRC_NAME\").encrypted_path" "$CONFIG_FILE")"
DST_DIR="$MNTDIR/$SRC_NAME.Open"
if [ -z "$SRC_DIR" ]; then
	>&2 echo "ERROR: Unable to detect encrypted_path for $SRC_NAME"
	exit 1
fi

if ! gxvault_gocryptfs_is_mounted "$SRC_DIR" ; then
	echo "Opening vault $SRC_NAME..."
	# echo "  src_name=$SRC_NAME"
	# echo "  src_dir=$SRC_DIR"
	# echo "  dst_dir=$DST_DIR"
	gxvault_gocryptfs_mount \
		"$SRC_NAME" \
		"$SRC_DIR" \
		"$DST_DIR"
else
	echo "Closing vault $SRC_NAME..."
	fusermount -u "$DST_DIR"
	printf '\033[32mVault %s is now closed\033[0m\n' "$SRC_NAME"
fi

