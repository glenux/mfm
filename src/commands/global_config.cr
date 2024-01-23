require "./abstract_command"

module GX::Commands
  class GlobalConfig < AbstractCommand
    def initialize(config : GX::Config)
    end

    def execute
    end

    def self.handles_mode
      GX::Types::Mode::GlobalConfig
    end
  end
end
