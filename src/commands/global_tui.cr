# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"
require "../file_system_manager"

module GX::Commands
  class GlobalTui < AbstractCommand
    @file_system_manager : FileSystemManager

    def initialize(@config : GX::Config)
      @config.load_from_env
      @config.load_from_file
      @file_system_manager = FileSystemManager.new(@config)
    end

    def execute
      raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?
      @file_system_manager.mount_or_umount(filesystem)
      @file_system_manager.auto_open(filesystem) if filesystem.mounted? && @config.auto_open?
    end

    def self.handles_mode
      GX::Types::Mode::GlobalTui
    end
  end
end
