
require "./config"
require "./fzf"

module GX
  class Cli
    @home_dir : String
    @config : Config

    def initialize()
      # Main execution starts here
      if !ENV["HOME"]?
        raise "Home directory not found"
      end
      @home_dir = ENV["HOME"]
      @config = Config.new(File.join(@home_dir, ".config/gx-vault.yml"))

      ## FIXME: check that FZF is installed
    end

    def run()
      # Correcting the fzf interaction part
      names_display = @config.vaults.map do |vault|
        vault.mounted? ? "#{vault.name} [#{ "open".colorize(:green) }]" : vault.name
      end

      selected_vault_name = Fzf.run(names_display.sort)
      puts ">> #{selected_vault_name}".colorize(:yellow)
      selected_vault = @config.vaults.find { |v| v.name == selected_vault_name }

      if selected_vault
        selected_vault.mounted? ? selected_vault.unmount : selected_vault.mount
      else
        STDERR.puts "Vault not found.".colorize(:red)
      end


    end


  end
end
