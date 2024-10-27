# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"

module GX::Commands
  class GlobalConfig < AbstractCommand
    def initialize(config : GX::Config)
    end

    def execute
    end

    def self.handles_mode
      GX::Types::Mode::GlobalConfig
    end
  end
end
