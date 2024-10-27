# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "../config"

module GX::Commands
  abstract class AbstractCommand
    abstract def initialize(config : GX::Config)

    abstract def execute

    def self.mode
      Gx::Types::Mode::None
    end
  end
end
