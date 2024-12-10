# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"
require "../file_system_manager"

module GX::Commands
  class MappingMount < AbstractCommand
    @file_system_manager : FileSystemManager

    def initialize(@config : GX::Config)
      @config.load_from_env
      @config.load_from_file
    end

    def execute
      filesystem = @config.root.try &.file_system_manager.choose_filesystem
      raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?
      filesystem.mount
      @file_system_manager.auto_open(filesystem) if filesystem.mounted? && @config.auto_open?
    end

    def self.handles_mode
      GX::Types::Mode::MappingMount
    end
  end
end
