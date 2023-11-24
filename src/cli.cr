# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "option_parser"
require "./config"
require "./fzf"
require "./version"

module GX
  class Cli
    Log = ::Log.for("cli")

    @config : Config

    def initialize()
      # Main execution starts here
      @config = Config.new

      ## FIXME: check that FZF is installed
    end

    def parse_command_line(args)
      # update 
      add_args = { name: "", path: "" }
      delete_args = { name: "" }
      pparser = OptionParser.new do |parser|
        parser.banner = "Usage: #{PROGRAM_NAME} [options]\n\nGlobal options"

        parser.on("-c", "--config FILE", "Set configuration file") do |path|
          Log.info { "Configuration set to #{path}" }
          @config.path = path
        end

        parser.on("-v", "--verbose", "Set more verbosity") do |flag|
          Log.info { "Verbosity enabled" }
          @config.verbose = true
        end

        parser.on("-o", "--open", "Automatically open directory after mount") do |flag|
          Log.info { "Auto-open enabled" }
          @config.auto_open = true
        end

        parser.on("--version", "Show version") do |flag|
          @config.mode = Config::Mode::ShowVersion
        end

        parser.on("-h", "--help", "Show this help") do |flag|
          STDOUT.puts parser
          exit(0)
        end

        parser.separator("\nCommands")
        parser.on("config", "Manage configuration") do 
          parser.banner = "Usage: #{PROGRAM_NAME} config [commands] [options]\n\nGlobal options"
          parser.separator("\nCommands")

          parser.on("create", "Create vault") do 
            @config.mode = Config::Mode::ConfigAdd

            parser.banner = "Usage: #{PROGRAM_NAME} config create [commands] [options]\n\nGlobal options"
            parser.separator("\nCommand options")

            parser.on("-n", "--name", "Set vault name") do |name|
              add_args = add_args.merge({ name: name })
            end
            parser.on("-p", "--path", "Set vault encrypted path") do |path|
              add_args = add_args.merge({ path: path })
            end
          end

          parser.on("delete", "Delete vault") do 
            @config.mode = Config::Mode::ConfigAdd

            parser.banner = "Usage: #{PROGRAM_NAME} delete [options]\n\nGlobal options"
            parser.separator("\nCommand options")

            parser.on("-n", "--name", "Set vault name") do |name|
              delete_args = delete_args.merge({ name: name })
            end
          end

          parser.on("edit", "Edit configuration") do |flag|
            @config.mode = Config::Mode::ConfigEdit
          end
        end

      end
      pparser.parse(args)
    end

    def run()
      case @config.mode 
      when Config::Mode::ShowVersion
        STDOUT.puts "#{PROGRAM_NAME} #{VERSION}"
      when Config::Mode::Mount
        @config.load_from_file
        filesystem = choose_filesystem
        raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?

        mount_or_umount(filesystem)
        auto_open(filesystem) if @config.auto_open
      end
    end

    def auto_open(filesystem)
      # FIXME: support xdg-open
      # FIXME: support mailcap
      # FIXME: support user-defined command
      # FIXME: detect graphical environment
      
      mount_point_safe = filesystem.mount_point
      raise Models::InvalidMountpointError.new("Invalid filesystem") if mount_point_safe.nil?

      if graphical_environment?
        process = Process.new(
          "xdg-open",  ## FIXME: make configurable
          [mount_point_safe],
          input: STDIN, 
          output: STDOUT, 
          error: STDERR
        )
        unless process.wait.success?
          puts "Error opening filesystem".colorize(:red)
          return
        end
      else
        process = Process.new(
          "vifm",  ## FIXME: make configurable
          [mount_point_safe],
          input: STDIN, 
          output: STDOUT, 
          error: STDERR
        )
        unless process.wait.success?
          puts "Error opening filesystem".colorize(:red)
          return
        end
      end
    end

    def graphical_environment?
      if ENV["DISPLAY"]? || ENV["WAYLAND_DISPLAY"]?
        return true
      end
      return false
    end

    def choose_filesystem()
      names_display = {} of String => NamedTuple(filesystem: Models::AbstractFilesystemConfig, ansi_name: String)

      config_root = @config.root
      return if config_root.nil?

      config_root.filesystems.each do |filesystem|
        fs_str = filesystem.type.ljust(12,' ')

        suffix = ""
        suffix_ansi = ""
        if filesystem.mounted? 
          suffix = "[open]"
          suffix_ansi = "[#{ "open".colorize(:green) }]"
        end

        result_name = "#{fs_str} #{filesystem.name} #{suffix}".strip
        ansi_name = "#{fs_str.colorize(:dark_gray)} #{filesystem.name} #{suffix_ansi}".strip

        names_display[result_name] = {
          filesystem: filesystem,
          ansi_name: ansi_name
        }
      end

      result_filesystem_name = Fzf.run(names_display.values.map(&.[:ansi_name]).sort).strip
      selected_filesystem = names_display[result_filesystem_name][:filesystem]
      puts ">> #{selected_filesystem.name}".colorize(:yellow)

      if !selected_filesystem
        STDERR.puts "Vault not found: #{selected_filesystem}.".colorize(:red)
        return
      end
      return selected_filesystem
    end

    def mount_or_umount(selected_filesystem)
      if !selected_filesystem.mounted?
        selected_filesystem.mount()
      else
        selected_filesystem.umount()
      end
    end
  end
end
