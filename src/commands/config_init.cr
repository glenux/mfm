require "./abstract_command"

module GX::Commands
  class ConfigInit < AbstractCommand
    def initialize(config : GX::Config) # FIXME
    end

    def execute
    end

    def self.handles_mode
      GX::Types::Mode::ConfigInit
    end
  end
end
