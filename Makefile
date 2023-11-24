# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

all: build

build:
	shards build --error-trace
	@echo SUCCESS

watch: 
	 watchexec --restart --delay-run 3 -c -e cr make build
