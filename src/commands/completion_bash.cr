require "./abstract_command"

module GX::Commands
  class CompletionBash < AbstractCommand
    def initialize(@config : GX::Config)
    end

    def execute
      completion_bash = FileStorage.get("completion.bash")
      STDOUT.puts completion_bash.gets_to_end
    end

    def self.handles_mode
      GX::Types::Mode::CompletionBash
    end
  end
end
