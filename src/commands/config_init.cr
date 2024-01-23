require "./abstract_command"

module GX::Commands
  class ConfigInit < AbstractCommand
    def initialize(config : GX::Config) # FIXME
    end

    def execute
      puts "FIXME: detect if config is present"
      puts "FIXME: compute config path (either default, or from command line)"
      puts "FIXME: create config file from default if needed"
    end

    def self.handles_mode
      GX::Types::Mode::ConfigInit
    end
  end
end
