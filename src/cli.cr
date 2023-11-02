# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "option_parser"
require "./config"
require "./fzf"

module GX
  VERSION="v0.1.9"

  class Cli

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
          @config.path = path
        end

        parser.on("-v", "--verbose", "Set more verbosity") do |flag|
          @config.verbose = true
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
      @config.load_from_file

      case @config.mode 
      when Config::Mode::ShowVersion
        STDOUT.puts "#{PROGRAM_NAME} #{VERSION}"
      when Config::Mode::Mount
        mount
      end
    end

    def mount()
      names_display = {} of String => NamedTuple(filesystem: Filesystem, ansi_name: String)
      @config.filesystems.each do |filesystem|
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

      if selected_filesystem
        selected_filesystem.mounted? ? selected_filesystem.unmount : selected_filesystem.mount
      else
        STDERR.puts "Vault not found: #{selected_filesystem}.".colorize(:red)
      end

    end
  end
end
