require "./abstract_command"

module GX::Commands
  class MappingCreate < AbstractCommand
    def initialize(@config : GX::Config) # FIXME
      @config.load_from_env
      @config.load_from_file
      @file_system_manager = FileSystemManager.new(@config)
    end

    def execute
      # FIXME: implement
      puts "mapping create yo!"
    end

    def self.handles_mode
      GX::Types::Mode::MappingCreate
    end
  end
end
