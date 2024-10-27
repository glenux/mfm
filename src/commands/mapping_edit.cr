# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"

module GX::Commands
  class MappingEdit < AbstractCommand
    def initialize(config : GX::Config) # FIXME
    end

    def execute
      # FIXME: implement
    end

    def self.handles_mode
      GX::Types::Mode::MappingEdit
    end
  end
end
