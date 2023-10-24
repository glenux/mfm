
require "option_parser"
require "./config"
require "./fzf"

module GX
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
        parser.banner = "Usage: gx-vault [options]\n\nGlobal options"

        parser.on("-c", "--config FILE", "Set configuration file") do |path|
          @config.path = path
        end
        parser.on("-h", "--help", "Show this help") do |flag|
          STDOUT.puts parser
          exit(0)
        end

        parser.separator("\nCommands")
        parser.on("create", "Create vault") do 
          @config.mode = Config::Mode::Add

          parser.banner = "Usage: gx-vault create [options]\n\nGlobal options"
          parser.separator("\nCommand options")

          parser.on("-n", "--name", "Set vault name") do |name|
            add_args = add_args.merge({ name: name })
          end
          parser.on("-p", "--path", "Set vault encrypted path") do |path|
            add_args = add_args.merge({ path: path })
          end
        end

        parser.on("delete", "Delete vault") do 
          @config.mode = Config::Mode::Add

          parser.banner = "Usage: gx-vault delete [options]\n\nGlobal options"
          parser.separator("\nCommand options")

          parser.on("-n", "--name", "Set vault name") do |name|
            delete_args = delete_args.merge({ name: name })
          end
        end

        parser.on("edit", "Edit configuration") do |flag|
          @config.mode = Config::Mode::Edit
        end

      end
      pparser.parse(args)
    end

    def run()
      @config.load_from_file

      names_display = {} of String => NamedTuple(vault: Vault, ansi_name: String)
      @config.vaults.each do |vault|
        result_name = vault.mounted? ? "#{vault.name} [open]" : vault.name
        ansi_name = vault.mounted? ? "#{vault.name} [#{ "open".colorize(:green) }]" : vault.name

        names_display[result_name] = {
          vault: vault,
          ansi_name: ansi_name
        }
      end

      result_vault_name = Fzf.run(names_display.values.map(&.[:ansi_name]).sort)
      selected_vault = names_display[result_vault_name][:vault]
      puts ">> #{selected_vault.name}".colorize(:yellow)

      if selected_vault
        selected_vault.mounted? ? selected_vault.unmount : selected_vault.mount
      else
        STDERR.puts "Vault not found: #{selected_vault}.".colorize(:red)
      end

    end
  end
end
