# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "yaml"
require "colorize"
require "json"
require "log"

require "./config"
require "./cli"

struct BaseFormat < Log::StaticFormatter
  def run
    string @entry.severity.label.downcase
    string "("
    source
    string "): "
    message
  end
end

Log.setup do |config|
  backend = Log::IOBackend.new(formatter: BaseFormat)
  config.bind "*", Log::Severity::Info, backend

  if ENV["LOG_LEVEL"]?
    level = Log::Severity.parse(ENV["LOG_LEVEL"]) || Log::Severity::Info
    config.bind "*", level, backend
  end
end

cli = GX::Cli.new
cli.parse_command_line(ARGV)
cli.run
