require "./base.cr"

module GX::Parsers
  class CompletionParser < AbstractParser
    def build(parser, ancestors, config)
      breadcrumbs = ancestors + "completion"

      parser.banner = Utils.usage_line(
        breadcrumbs,
        "Manage #{PROGRAM_NAME} completion",
        true
      )
      parser.separator("\nCompletion commands:")

      parser.on("--bash", "Generate bash completion") do |flag|
        Log.info { "Set bash completion" }
      end

      parser.on("--zsh", "Generate zsh completion") do |flag|
        Log.info { "Set zsh completion" }
      end

      parser.separator Utils.help_line(breadcrumbs)
    end
  end
end
