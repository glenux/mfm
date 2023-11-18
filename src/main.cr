# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "yaml"
require "colorize"
require "json"

require "./filesystems/gocryptfs"
require "./file_storage"
require "./config"
require "./cli"

app = GX::Cli.new
app.parse_command_line(ARGV)
app.run


