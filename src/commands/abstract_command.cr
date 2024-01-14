require "../config"

module GX::Commands
  abstract class AbstractCommand
    abstract def initialize(config : GX::Config)

    abstract def execute

    def self.mode
      Gx::Types::Mode::None
    end
  end
end
