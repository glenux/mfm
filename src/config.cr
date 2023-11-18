# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "./filesystems"

module GX
  class Config
    Log = ::Log.for("config")

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

    getter filesystems : Array(Filesystem)
    getter home_dir : String
    property verbose : Bool
    property mode : Mode
    property path : String
    property args : AddArgs.class | DelArgs.class | NoArgs.class

    def initialize()
      if !ENV["HOME"]?
        raise "Home directory not found"
      end
      @home_dir = ENV["HOME"]

      @verbose = false
      @mode = Mode::Mount
      @filesystems = [] of Filesystem
      @path = detect_config_file()

      @args = NoArgs
    end

    def detect_config_file()
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
      raise "Configuration file not found"
    end

    def load_from_file
      @filesystems = [] of Filesystem

      if !File.exists? @path
        Log.error { "File #{@path} does not exist!".colorize(:red) }
        exit(1)
      end
      load_filesystems(@path)
    end

    private def load_filesystems(config_path : String)
      yaml_data = YAML.parse(File.read(config_path))
      vaults_data = yaml_data["filesystems"].as_a

      vaults_data.each do |filesystem_data|
        type = filesystem_data["type"].as_s
        name = filesystem_data["name"].as_s
        # encrypted_path = filesystem_data["encrypted_path"].as_s
        @filesystems << Filesystem.from_yaml(filesystem_data.to_yaml)
        # @filesystems << Filesystem.new(name, encrypted_path, "#{name}.Open")
      end
    end
  end
end
