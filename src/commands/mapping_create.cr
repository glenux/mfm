require "./abstract_command"

module GX::Commands
  class MappingCreate < AbstractCommand
    def initialize(@config : GX::Config) # FIXME
      @config.load_from_env
      @config.load_from_file
    end

    def execute
      # Assuming create_args is passed to this command with necessary details
      create_args = @config.create_args

      # Validate required arguments
      if create_args[:name].empty? || create_args[:path].empty?
        raise ArgumentError.new("Name and path are required to create a mapping.")
      end

      # Create the appropriate filesystem config based on the type
      filesystem_config = case create_args[:type]
      when "gocryptfs"
        GX::Models::GocryptfsConfig.new(
          name: create_args[:name],
          path: create_args[:path],
          encrypted_path: create_args[:encrypted_path]
        )
      when "sshfs"
        GX::Models::SshfsConfig.new(
          name: create_args[:name],
          path: create_args[:path],
          remote_user: create_args[:remote_user],
          remote_host: create_args[:remote_host],
          remote_path: create_args[:remote_path],
          remote_port: create_args[:remote_port]
        )
      when "httpdirfs"
        GX::Models::HttpdirfsConfig.new(
          name: create_args[:name],
          path: create_args[:path],
          url: create_args[:url]
        )
      else
        raise ArgumentError.new("Unsupported mapping type: #{create_args[:type]}")
      end

      # Append the new filesystem config to the root config
      @config.root.try &.filesystems << filesystem_config

      puts "Mapping '#{create_args[:name]}' created and added to configuration successfully."
    end

    def self.handles_mode
      GX::Types::Mode::MappingCreate
    end
  end
end
