require "./abstract_command"
require "../config"

module GX::Commands
  class GlobalVersion < AbstractCommand
    def initialize(config : GX::Config) # FIXME
    end

    def execute
      STDOUT.puts "#{File.basename PROGRAM_NAME} #{VERSION}"
    end

    def self.handles_mode
      GX::Types::Mode::GlobalVersion
    end
  end
end
