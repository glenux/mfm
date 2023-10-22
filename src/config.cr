
require "./vault"

module GX
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
end
