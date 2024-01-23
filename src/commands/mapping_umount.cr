require "./abstract_command"
require "../file_system_manager"

module GX::Commands
  class MappingUmount < AbstractCommand
    @file_system_manager : FileSystemManager

    def initialize(@config : GX::Config)
      @config.load_from_env
      @config.load_from_file
      @file_system_manager = FileSystemManager.new(@config)
    end

    def execute
      filesystem = @file_system_manager.choose_filesystem
      raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?
      filesystem.umount
    end

    def self.handles_mode
      GX::Types::Mode::MappingUmount
    end
  end
end
