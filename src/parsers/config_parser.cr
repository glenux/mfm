require "./options/config_options"
require "./options/config_init_options"
require "./base"
require "../types/modes"
require "../utils/parser_lines"

module GX::Parsers
  class ConfigParser < AbstractParser
    def build(parser, ancestors, config)
      breadcrumbs = ancestors + "config"
      config.config_options = Parsers::Options::ConfigOptions.new
      parser.banner = Utils.usage_line(
        breadcrumbs,
        "Helpers for #{PROGRAM_NAME}'s configuration file",
        true
      )
      parser.separator("\nConfig commands")

      parser.on("init", "Create initial mfm configuration") do
        config.mode = Types::Mode::ConfigInit
        config.config_init_options = Parsers::Options::ConfigInitOptions.new

        parser.banner = Utils.usage_line(breadcrumbs + "init", "Create initial mfm configuration")
        parser.separator("\nInit options")

        parser.on("-p", "--path", "Set mapping encrypted path") do |path|
          config.config_init_options.try do |opts|
            opts.path = path
          end
        end

        parser.separator(Utils.help_line(breadcrumbs + "init"))
      end

      parser.separator(Utils.help_line(breadcrumbs))
    end
  end
end
