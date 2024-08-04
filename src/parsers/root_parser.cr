require "./base"
require "./config_parser"
require "./mapping_parser"
require "./completion_parser"
require "../utils/parser_lines"
require "../commands"

module GX::Parsers
  class RootParser < AbstractParser
    def build(parser, ancestors, config)
      breadcrumbs = ancestors + (File.basename PROGRAM_NAME)

      parser.banner = Utils.usage_line(
        breadcrumbs,
        "A management tool for your various FUSE filesystems",
        true
      )

      parser.on("-c", "--config FILE", "Set configuration file") do |path|
        Log.info { "Configuration set to #{path}" }
        config.path = path
      end

      parser.on("-v", "--verbose", "Set more verbosity") do |_|
        Log.info { "Verbosity enabled" }
        config.verbose = true
      end

      parser.on("-o", "--open", "Automatically open directory after mount") do |_|
        Log.info { "Auto-open enabled" }
        config.auto_open = true
      end

      parser.on("--version", "Show version") do |_|
        config.mode = Types::Mode::GlobalVersion
      end

      parser.on("-h", "--help", "Show this help") do |_|
        config.mode = Types::Mode::GlobalHelp
        config.help_options = Parsers::Options::HelpOptions.new
        config.help_options.try(&.parser_snapshot=(parser.dup))
      end

      parser.separator("\nGlobal commands:")

      parser.on("config", "Manage configuration file") do
        config.mode = Types::Mode::GlobalHelp
        config.help_options = Parsers::Options::HelpOptions.new
        config.help_options.try(&.parser_snapshot=(parser.dup))

        # config.command = Commands::Config.new(config)
        Parsers::ConfigParser.new.build(parser, breadcrumbs, config)
      end

      parser.on("tui", "Interactive text user interface (default)") do
        config.mode = Types::Mode::GlobalTui
      end

      parser.on("mapping", "Manage mappings") do
        config.mode = Types::Mode::GlobalHelp
        config.help_options = Parsers::Options::HelpOptions.new
        config.help_options.try(&.parser_snapshot=(parser.dup))

        Parsers::MappingParser.new.build(parser, breadcrumbs, config)
      end

      # parser.on("interactive", "Interactive mapping mount/umount") do
      #   abort("FIXME: Not implemented")
      # end

      parser.on("completion", "Manage completion") do
        config.mode = Types::Mode::GlobalHelp
        config.help_options = Parsers::Options::HelpOptions.new
        config.help_options.try(&.parser_snapshot=(parser.dup))

        Parsers::CompletionParser.new.build(parser, breadcrumbs, config)
      end

      parser.separator(Utils.help_line(breadcrumbs))

      # Manage errors
      parser.unknown_args do |remaining_args, _|
        next if remaining_args.size == 0

        puts parser
        abort("ERROR: Invalid arguments: #{remaining_args.join(" ")}")
      end

      parser.invalid_option do |ex|
        puts parser
        abort("ERROR: Invalid option: '#{ex}'!")
      end
    end
  end
end
