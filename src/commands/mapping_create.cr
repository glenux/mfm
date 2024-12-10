# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"

module GX::Commands
  class MappingCreate < AbstractCommand
    def initialize(@config : GX::Config)
      @config.load_from_env
      @config.load_from_file
    end

    def execute
      # Assuming mapping_create_options is passed to this command with necessary details
      create_options = @config.mapping_create_options

      # Validate required arguments
      if create_options.nil?
        raise ArgumentError.new("Mapping create options are required")
      end
      if create_options.name.nil? || create_options.name.try &.empty?
        raise ArgumentError.new("Name is required to create a mapping.")
      end
      if create_options.type.nil? || create_options.type.try &.empty?
        raise ArgumentError.new("Type is required to create a mapping.")
      end

      # Create the appropriate filesystem config based on the type
      filesystem_config = GX::Models::FilesystemFactory.build(create_options)

      # Append the new filesystem config to the root config
      @config.root.try do |root|
        root.filesystems ||= [] of GX::Models::AbstractFilesystemConfig
        root.filesystems << filesystem_config
        root.file_system_manager.mount_or_umount(filesystem_config)
      end

      puts "Mapping '#{create_options.name}' created and added to configuration successfully."
    end

    def self.handles_mode
      GX::Types::Mode::MappingCreate
    end


    # validate create_options.PARAMETER and display error with description if
    # missing
    macro option_check(create_options, parameter, description)
      if create_options.{{ parameter.id }}.nil? || create_options.{{ parameter.id }}.try &.empty?
        raise ArgumentError.new("Parameter for " + {{description}} + " is required")
      end
    end
  end
end
