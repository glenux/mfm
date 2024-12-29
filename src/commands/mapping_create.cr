require "./abstract_command"

module GX::Commands
  class MappingCreate < AbstractCommand
    def initialize(config : GX::Config) # FIXME
    end

    def execute
      # FIXME: implement
    end

    def self.handles_mode
      GX::Types::Mode::MappingCreate
    end
  end
end
