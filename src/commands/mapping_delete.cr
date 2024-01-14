require "./abstract_command"

module GX::Commands
  class MappingDelete < AbstractCommand
    def initialize(config : GX::Config) # FIXME
    end

    def execute
      # FIXME: implement
    end

    def self.handles_mode
      GX::Types::Mode::MappingDelete
    end
  end
end
