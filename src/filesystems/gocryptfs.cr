# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "shellwords"
require "./filesystem"

module GX
  class GoCryptFS < Filesystem
    getter name : String = ""
    getter encrypted_path : String = ""

    @[YAML::Field(key: "mount_dir", ignore: true)]
    getter mount_dir : String = ""

    include GenericFilesystem

    def after_initialize()
      home_dir = ENV["HOME"] || raise "Home directory not found"
      @mount_dir = File.join(home_dir, "mnt/#{@name}.Open")
    end

    def mounted? : Bool
      `mount`.includes?("#{encrypted_path} on #{mount_dir}")
    end

    def mount
      super do 
        input = STDIN
        output = STDOUT
        error = STDERR
        process = Process.new(
          "gocryptfs", 
          ["-idle", "15m", encrypted_path, mount_dir], 
          input: input, 
          output: output, 
          error: error
        )
        unless process.wait.success?
          puts "Error mounting the vault".colorize(:red)
          return
        end
      end
    end
  end
end
