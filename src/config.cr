
require "./filesystems"

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

    getter filesystems : Array(Filesystem)
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
      @filesystems = [] of Filesystem
      @path = File.join(@home_dir, ".config", DEFAULT_CONFIG_PATH)
      @args = NoArgs
    end

    def load_from_file
      @filesystems = [] of Filesystem

      if !File.exists? @path
        STDERR.puts "Error: file #{@path} does not exist!".colorize(:red)
        exit(1)
      end
      load_filesystems(@path)
    end

    private def load_filesystems(config_path : String)
      yaml_data = YAML.parse(File.read(config_path))
      vaults_data = yaml_data["filesystems"].as_a

      vaults_data.each do |filesystem_data|
        type = filesystem_data["type"].as_s
        name = filesystem_data["name"].as_s
        # encrypted_path = filesystem_data["encrypted_path"].as_s
        @filesystems << Filesystem.from_yaml(filesystem_data.to_yaml)
        # @filesystems << Filesystem.new(name, encrypted_path, "#{name}.Open")
      end
    end
  end
end
