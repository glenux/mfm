require "../spec_helper"
require "../../src/commands/mapping_edit"

describe GX::Commands::MappingEdit do
  context "Initialization" do
    it "initializes with a mock FileSystemManager" do
      config = GX::Config.new
      command = GX::Commands::MappingEdit.new(config)
      command.should be_a(GX::Commands::MappingEdit)
    end
  end
end
