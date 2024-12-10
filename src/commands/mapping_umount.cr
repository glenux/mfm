# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"
require "../file_system_manager"

module GX::Commands
  class MappingUmount < AbstractCommand
    def initialize(@config : GX::Config)
      @config.load_from_env
      @config.load_from_file
    end

    def execute
      # root = @config.root
      # raise "Missing root config" if root.nil?

      # filesystem = root.file_system_manager.choose_filesystem
      # raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?

      # filesystem.umount
    end

    def self.handles_mode
      GX::Types::Mode::MappingUmount
    end

    # OBSOLETE:
    private def umount_filesystem(filesystem : Models::AbstractFilesystemConfig)
      raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?
      unless filesystem.mounted?
        Log.info { "Filesystem is not mounted." }
        return
      end
      filesystem.umount
    end
  end
end
