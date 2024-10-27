# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"

module GX::Commands
  class GlobalHelp < AbstractCommand
    def initialize(@config : GX::Config)
    end

    def execute
      STDOUT.puts ""
      @config.help_options.try { |opts| puts opts.parser_snapshot }
      exit(0)
    end

    def self.handles_mode
      GX::Types::Mode::GlobalHelp
    end
  end
end
