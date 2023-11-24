# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "crinja"

require "./models"

module GX
  class Config
    Log = ::Log.for("config")

    class MissingFileError < Exception
    end

    enum Mode
      ConfigAdd
      ConfigDelete
      ConfigEdit
      ShowVersion
      Mount
    end

    record NoArgs
    record AddArgs, name : String, path : String
    record DelArgs, name : String

    # getter filesystems : Array(Models::AbstractFilesystemConfig)
    getter home_dir : String
    getter root : Models::RootConfig?

    property verbose : Bool
    property mode : Mode
    property path : String?
    property args : AddArgs.class | DelArgs.class | NoArgs.class
    property auto_open : Bool

    def initialize()
      raise Models::InvalidEnvironmentError.new("Home directory not found") if !ENV["HOME"]?
      @home_dir = ENV["HOME"]

      @verbose = false
      @auto_open = false

      @mode = Mode::Mount
      @filesystems = [] of Models::AbstractFilesystemConfig
      @path = nil

      @args = NoArgs
    end

    private def detect_config_file()
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

      root = Models::RootConfig.from_yaml(file_patched)

      global_mount_point = root.global.mount_point
      raise Models::InvalidMountpointError.new("Invalid global mount point") if global_mount_point.nil?

      root.filesystems.each do |selected_filesystem|
        if !selected_filesystem.mount_point?
          selected_filesystem.mount_point = 
            File.join(global_mount_point, selected_filesystem.mounted_name)
        end
      end
      @root = root
    end
  end
end
