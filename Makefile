# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

PREFIX=/usr

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
		-m 755 \
		bin/code-preloader \
		$(PREFIX)/bin

.PHONY: spec test build all prepare install

