# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./abstract_command"
require "../file_storage"

module GX::Commands
  class ConfigInit < AbstractCommand
    def initialize(@config : GX::Config)
    end

    def execute
      config_dir = File.join(@config.home_dir, ".config", "mfm")
      config_file_path = File.join(config_dir, "config.yml")

      # Override the configuration path if provided
      puts "Configuration file path: #{config_file_path}"
      puts "Configuration file path: #{@config.path}"
      pp @config
      @config.path.try do |path|
        config_file_path = path
        config_dir = File.dirname(path)
      end
      exit 1

      # Guard condition to exit if the configuration file already exists
      if File.exists?(config_file_path)
        puts "Configuration file already exists at #{config_file_path}. No action taken."
        return
      end

      puts "Creating initial configuration file at #{config_file_path}"

      # Ensure the configuration directory exists
      FileUtils.mkdir_p(config_dir)

      # Read the default configuration content from the baked file storage
      default_config_content = FileStorage.get("sample.mfm.yaml")

      # Write the default configuration to the target path
      File.write(config_file_path, default_config_content)

      puts "Configuration file created successfully."
    rescue ex
      STDERR.puts "Error creating the configuration file: #{ex.message}"
      exit(1)
    end

    def self.handles_mode
      GX::Types::Mode::ConfigInit
    end
  end
end
