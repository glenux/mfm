
require "../spec_helper"
require "../../src/commands/mapping_list"
require "../../src/models/gocryptfs_config"
require "../../src/models/sshfs_config"
require "../../src/models/httpdirfs_config"

describe GX::Commands::MappingList do
  context "Initialization" do
    it "initializes with a mock FileSystemManager and RootConfig" do
      config = GX::Config.new
      root_config = GX::Models::RootConfig.new
      command = GX::Commands::MappingList.new(config)
      command.should be_a(GX::Commands::MappingList)
    end
  end

  context "Functioning" do
    it "lists mappings when there are no filesystems" do
      config = GX::Config.new
      root_config = GX::Models::RootConfig.new
      command = GX::Commands::MappingList.new(config)

      output = capture_output do
        command.execute
      end

      output.should include("TYPE")
      output.should include("NAME")
      output.should include("MOUNTED")
    end

    it "lists mappings when there are multiple filesystems" do
      config = GX::Config.new
      root_config = GX::Models::RootConfig.new

      gocryptfs_config = GX::Models::GoCryptFSConfig.new(
        GX::Parsers::Options::MappingCreateOptions.new(
          type: "gocryptfs",
          name: "test_gocryptfs",
          encrypted_path: "/encrypted/path"
        )
      )
      sshfs_config = GX::Models::SshFSConfig.new(
        GX::Parsers::Options::MappingCreateOptions.new(
          type: "sshfs",
          name: "test_sshfs",
          remote_user: "user",
          remote_host: "host",
          remote_path: "/remote/path"
        )
      )
      httpdirfs_config = GX::Models::HttpDirFSConfig.new(
        GX::Parsers::Options::MappingCreateOptions.new(
          type: "httpdirfs",
          name: "test_httpdirfs",
          url: "http://example.com"
        )
      )

      root_config.add_filesystem(gocryptfs_config)
      root_config.add_filesystem(sshfs_config)
      root_config.add_filesystem(httpdirfs_config)

      command = GX::Commands::MappingList.new(config)

      output = capture_output do
        command.execute
      end

      output.should include("gocryptfs")
      output.should include("test_gocryptfs")
      output.should include("false")

      output.should include("sshfs")
      output.should include("test_sshfs")
      output.should include("false")

      output.should include("httpdirfs")
      output.should include("test_httpdirfs")
      output.should include("false")
    end

    it "ensures the output format is correct" do
      config = GX::Config.new
      root_config = GX::Models::RootConfig.new
      config.instance_variable_set("@root", root_config)

      gocryptfs_config = GX::Models::GoCryptFSConfig.new(
        GX::Parsers::Options::MappingCreateOptions.new(
          type: "gocryptfs",
          name: "test_gocryptfs",
          encrypted_path: "/encrypted/path"
        )
      )
      root_config.add_filesystem(gocryptfs_config)

      command = GX::Commands::MappingList.new(config)

      output = capture_output do
        command.execute
      end

      output.should match(/TYPE\s+NAME\s+MOUNTED/)
      output.should match(/gocryptfs\s+test_gocryptfs\s+false/)
    end
  end
end
