# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "option_parser"
require "./config"
require "./version"
require "./parsers/root_parser"
require "./utils/breadcrumbs"
require "./utils/fzf"
require "./file_system_manager"
require "./command_factory"

module GX
  class Cli
    Log = ::Log.for("cli")

   @config : GX::Config

    def initialize
      # Main execution starts here
      # # FIXME: add a method to verify that FZF is installed
      @config = Config.new
    end

    def parse_command_line(args)
      pparser = OptionParser.new do |parser|
        breadcrumbs = Utils::BreadCrumbs.new([] of String)
        Parsers::RootParser.new.build(parser, breadcrumbs, @config)
      end
      pparser.parse(args)
    end

    def run
      command = CommandFactory.create_command(@config, @config.mode)
      abort("ERROR: unknown command for mode #{@config.mode}") if command.nil?

      command.try &.execute
    end
  end
end
