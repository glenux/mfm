# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"
require "../config"

module GX::Commands
  class GlobalVersion < AbstractCommand
    def initialize(config : GX::Config)
    end

    def execute
      STDOUT.puts "#{File.basename PROGRAM_NAME} #{VERSION}"
    end

    def self.handles_mode
      GX::Types::Mode::GlobalVersion
    end
  end
end
