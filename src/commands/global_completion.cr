# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"

module GX::Commands
  class GlobalCompletion < AbstractCommand
    def initialize(@config : GX::Config)
    end

    def execute
      puts "FIXME: detect option (either zsh or bash)"
      puts "FIXME: output the right file from embedded data"
    end

    def self.handles_mode
      GX::Types::Mode::GlobalCompletion
    end
  end
end
