require "./abstract_command"

module GX::Commands
  class GlobalCompletion < AbstractCommand
    def initialize(@config : GX::Config)
    end

    def execute
      puts "FIXME: detect option (either zsh or bash)"
      puts "FIXME: output the right file from embedded data"
    end

    def self.handles_mode
      GX::Types::Mode::GlobalCompletion
    end
  end
end
