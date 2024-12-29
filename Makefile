# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

DESTDIR=
PREFIX=$(DESTDIR)/usr

all: build

prepare:
	shards install

build:
	shards build --error-trace -Dpreview_mt
	@echo SUCCESS

watch: 
	 watchexec --restart --delay-run 3 -c -e cr make build

spec: test
test:
	crystal spec --error-trace

install:
	install \
		-D \
		-m 755 \
		bin/mfm \
		$(PREFIX)/bin/mfm

.PHONY: spec test build all prepare install

