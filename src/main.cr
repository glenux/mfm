require "yaml"
require "colorize"
require "json"

# Vault class
class Vault
  getter name : String
  getter encrypted_path : String
  getter mount_dir : String

  def initialize(@name, @encrypted_path, mount_name : String)
    home_dir = ENV["HOME"] || raise "Home directory not found"
    @mount_dir = File.join(home_dir, "mnt/#{mount_name}")
  end

  def mounted? : Bool
    `mount`.includes?("#{encrypted_path} on #{mount_dir}")
  end

  def mount
    Dir.mkdir_p(mount_dir) unless Dir.exists?(mount_dir)

    if mounted?
      puts "Already mounted. Skipping.".colorize(:yellow)
    else
      input = STDIN
      output = STDOUT
      error = STDERR
      process = Process.new("gocryptfs", ["-idle", "15m", encrypted_path, mount_dir], input: input, output: output, error: error)
      unless process.wait.success?
        puts "Error mounting the vault".colorize(:red)
        return
      end
      puts "Vault #{name} is now available on #{mount_dir}".colorize(:green)
    end
  end
  def unmount
    `fusermount -u #{mount_dir}`
    puts "Vault #{name} is now closed.".colorize(:green)
  end
end

# Config class
class Config
  getter vaults : Array(Vault)

  def initialize(config_path : String)
    @vaults = [] of Vault
    load_vaults(config_path)
  end

  private def load_vaults(config_path : String)
    yaml_data = YAML.parse(File.read(config_path))
    vaults_data = yaml_data["vaults"].as_a

    vaults_data.each do |vault_data|
      name = vault_data["name"].as_s
      encrypted_path = vault_data["encrypted_path"].as_s
      @vaults << Vault.new(name, encrypted_path, "#{name}.Open")
    end
  end
end

# Main execution starts here
home_dir = ENV["HOME"] || raise "Home directory not found"
config = Config.new(File.join(home_dir, ".config/gx-vault.yml"))

# Correcting the fzf interaction part
input = IO::Memory.new
config.vaults.each do |vault|
  name_display = vault.mounted? ? "#{vault.name} [#{ "open".colorize(:green) }]" : vault.name
  input.puts name_display
end
input.rewind

output = IO::Memory.new
error = STDERR
process = Process.new("fzf", ["--ansi"], input: input, output: output, error: error)

unless process.wait.success?
  puts "Error executing fzf: #{error.to_s.strip}".colorize(:red)
  exit(1)
end

selected_vault_name = output.to_s.strip.split.first?
selected_vault = config.vaults.find { |v| v.name == selected_vault_name }

if selected_vault
  selected_vault.mounted? ? selected_vault.unmount : selected_vault.mount
else
  puts "Vault not found.".colorize(:red)
end

