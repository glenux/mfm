# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "shellwords"
require "./abstract_filesystem"
require "./concerns/base"

module GX
  module Filesystem
    class GoCryptFS < AbstractFilesystem
      getter name : String = ""
      getter encrypted_path : String = ""

      @[YAML::Field(key: "mount_dir", ignore: true)]
      getter mount_dir : String = ""

      include Concerns::Base

      def mounted_prefix()
        "#{encrypted_path}"
      end

      def mount
        _mount_wrapper do 
          process = Process.new(
            "gocryptfs", 
            ["-idle", "15m", encrypted_path, mount_dir], 
            input: STDIN, 
            output: STDOUT, 
            error: STDERR
          )
          unless process.wait.success?
            puts "Error mounting the vault".colorize(:red)
            return
          end
        end
      end
    end
  end
end
