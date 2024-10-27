require "../spec_helper"
require "../../src/commands/mapping_create"

describe GX::Commands::MappingCreate do
  context "Initialization" do
    it "initializes with a mock FileSystemManager and RootConfig" do
      config = GX::Config.new
      root_config = GX::Models::RootConfig.new
      command = GX::Commands::MappingCreate.new(config)
      command.should be_a(GX::Commands::MappingCreate)
    end
  end
end
