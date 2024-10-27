# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "crinja"

require "./models"
require "./types/modes"
require "./parsers/options/help_options"
require "./parsers/options/config_options"
require "./parsers/options/config_init_options"
require "./parsers/options/mapping_create_options"
require "./parsers/options/mapping_delete_options"
require "./parsers/options/mapping_mount_options"
require "./parsers/options/mapping_umount_options"
require "./commands/abstract_command"

module GX
  class Config
    Log = ::Log.for("config")

    class MissingFileError < Exception
    end

    record NoArgs
    record AddArgs, name : String, path : String
    record DelArgs, name : String

    # getter filesystems : Array(Models::AbstractFilesystemConfig)
    getter home_dir : String
    getter root : Models::RootConfig?

    property verbose : Bool
    property mode : Types::Mode
    property path : String?
    property args : AddArgs.class | DelArgs.class | NoArgs.class
    property auto_open : Bool

    # FIXME: refactor and remove these parts from here
    property help_options : Parsers::Options::HelpOptions?
    property config_init_options : Parsers::Options::ConfigInitOptions?
    property config_options : Parsers::Options::ConfigOptions?
    property mapping_create_options : Parsers::Options::MappingCreateOptions?

    def initialize
      raise Models::InvalidEnvironmentError.new("Home directory not found") if !ENV["HOME"]?
      @home_dir = ENV["HOME"]

      @verbose = false
      @auto_open = false

      @mode = Types::Mode::GlobalTui
      @filesystems = [] of Models::AbstractFilesystemConfig
      @path = nil

      @args = NoArgs
    end

    private def detect_config_file
      possible_files = [
        File.join(@home_dir, ".config", "mfm", "config.yaml"),
        File.join(@home_dir, ".config", "mfm", "config.yml"),
        File.join(@home_dir, ".config", "mfm.yaml"),
        File.join(@home_dir, ".config", "mfm.yml"),
        File.join("/etc", "mfm", "config.yaml"),
        File.join("/etc", "mfm", "config.yml"),
      ]

      possible_files.each do |file_path|
        if File.exists?(file_path)
          Log.info { "Configuration file found: #{file_path}" }
          return file_path if File.exists?(file_path)
        else
          Log.debug { "Configuration file not found: #{file_path}" }
        end
      end

      Log.error { "No configuration file found in any of the standard locations" }
      raise MissingFileError.new("Configuration file not found")
    end

    def load_from_env
      if !ENV["FZF_DEFAULT_OPTS"]?
        # force defaults settings if none defined
        ENV["FZF_DEFAULT_OPTS"] = "--height 40% --layout=reverse --border"
      end
    end

    def load_from_file
      config_path = @path
      if config_path.nil?
        config_path = detect_config_file()
      end
      @path = config_path

      if !File.exists? config_path
        Log.error { "File #{path} does not exist!".colorize(:red) }
        exit(1)
      end

      file_data = File.read(config_path)
      file_patched = Crinja.render(file_data, {"env" => ENV.to_h})

      begin
        root = Models::RootConfig.from_yaml(file_patched)
      rescue ex : YAML::ParseException
        STDERR.puts "Error parsing configuration file: #{ex.message}".colorize(:red)
        exit(1)
      end

      mount_point_base_safe = root.global.mount_point_base
      raise Models::InvalidMountpointError.new("Invalid global mount point") if mount_point_base_safe.nil?

      root.filesystems.each do |selected_filesystem|
        if !selected_filesystem.mount_point?
          selected_filesystem.mount_point =
            File.join(mount_point_base_safe, selected_filesystem.mounted_name)
        end
      end
      @root = root
    end
  end
end
