
module GX
  class Fzf

    def self.run(list : Array(String)) : String
      input = IO::Memory.new
      input.puts list.join("\n")
      input.rewind

      output = IO::Memory.new
      error = STDERR
      process = Process.new("fzf", ["--ansi"], input: input, output: output, error: error)

      unless process.wait.success?
        STDERR.puts "Error executing fzf: #{error.to_s.strip}".colorize(:red)
        exit(1)
      end

      result = output.to_s.strip #.split.first?
    end
  end
end

