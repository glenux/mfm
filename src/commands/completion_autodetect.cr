require "./abstract_command"

module GX::Commands
  class CompletionAutodetect < AbstractCommand
    def initialize(@config : GX::Config)
    end

    def execute
      STDERR.puts "FIXME: Completion auto-detection isn't implemented yet. Please select one of the following: --bash or --zsh"
      exit(0)
    end

    def self.handles_mode
      GX::Types::Mode::CompletionAutodetect
    end
  end
end
