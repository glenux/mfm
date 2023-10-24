
require "./filesystems/gocryptfs"

module GX
  class Config
    enum Mode
      Add
      Edit
      Run
    end

    record NoArgs
    record AddArgs, name : String, path : String
    record DelArgs, name : String

    getter filesystems : Array(GoCryptFS)
    getter home_dir : String
    property mode : Mode
    property path : String
    property args : AddArgs.class | DelArgs.class | NoArgs.class

    DEFAULT_CONFIG_PATH = "mfm.yml"

    def initialize()
      if !ENV["HOME"]?
        raise "Home directory not found"
      end
      @home_dir = ENV["HOME"]

      @mode = Mode::Run
      @filesystems = [] of GoCryptFS
      @path = File.join(@home_dir, ".config", DEFAULT_CONFIG_PATH)
      @args = NoArgs
    end

    def load_from_file
      @filesystems = [] of GoCryptFS

      if !File.exists? @path
        STDERR.puts "Error: file #{@path} does not exist!".colorize(:red)
        exit(1)
      end
      load_vaults(@path)
    end

    private def load_vaults(config_path : String)
      yaml_data = YAML.parse(File.read(config_path))
      vaults_data = yaml_data["filesystems"].as_a

      vaults_data.each do |vault_data|
        type = vault_data["type"].as_s
        name = vault_data["name"].as_s
        encrypted_path = vault_data["encrypted_path"].as_s
        @filesystems << GoCryptFS.new(name, encrypted_path, "#{name}.Open")
      end
    end
  end
end
