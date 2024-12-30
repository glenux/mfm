# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

DESTDIR=
PREFIX=$(DESTDIR)/usr

.PHONY: all
all: build

.PHONY: prepare
prepare:
	shards install

.PHONY: build
build:
	shards build --error-trace -Dpreview_mt
	@echo SUCCESS

watch: 
	 watchexec --restart --delay-run 3 -c -e cr make build

.PHONY: spec test
spec: test
test:
	crystal spec --error-trace

.PHONY: install
install:
	install \
		-D \
		-m 755 \
		bin/mfm \
		$(PREFIX)/bin/mfm

.PHONY: deb
deb:
	dpkg-buildpackage -us -uc -d

