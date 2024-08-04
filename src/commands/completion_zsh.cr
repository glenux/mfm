require "./abstract_command"

module GX::Commands
  class CompletionZsh < AbstractCommand
    def initialize(@config : GX::Config)
    end

    def execute
      completion_bash = FileStorage.get("completion.zsh")
      STDOUT.puts completion_bash.gets_to_end
    end

    def self.handles_mode
      GX::Types::Mode::CompletionZsh
    end
  end
end
