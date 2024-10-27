# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./commands"

module GX
  class CommandFactory
    def self.create_command(config : GX::Config, mode : GX::Types::Mode) : Commands::AbstractCommand?
      classes = {{ Commands::AbstractCommand.all_subclasses }}
      command_klass = classes.find { |klass| klass.handles_mode == mode }
      command_klass.try &.new(config)
    end
  end
end
