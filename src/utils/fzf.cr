# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

module GX::Utils
  class Fzf
    def self.run(list : Array(String)) : String
      input = IO::Memory.new
      input.puts list.join("\n")
      input.rewind

      output = IO::Memory.new
      error = STDERR
      process = Process.new("fzf", ["--ansi"], input: input, output: output, error: error)

      status = process.wait
      case status.exit_code
      when 0
      when 1
        STDERR.puts "No match".colorize(:red)
        exit(1)
      when 130
        STDERR.puts "Interrupted".colorize(:red)
        exit(1)
      else # includes retcode = 2 (error)
        STDERR.puts "Error executing fzf: #{error.to_s.strip} (#{status.exit_code})".colorize(:red)
        exit(1)
      end

      result = output.to_s.strip # .split.first?
    end
  end
end
