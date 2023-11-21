# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "shellwords"
require "./abstract_filesystem"
require "./concerns/base"

module GX
  module Filesystem
  class HttpDirFS < AbstractFilesystem
    getter name : String = ""
    getter url : String = ""

    @[YAML::Field(key: "mount_dir", ignore: true)]
    getter mount_dir : String = ""

    include Concerns::Base

    def mounted_prefix()
      "httpdirfs"
    end

    def mount
      _mount_wrapper do 
        process = Process.new(
          "httpdirfs", 
          ["#{url}", mount_dir], 
          input: STDIN, 
          output: STDOUT, 
          error: STDERR
        )
        unless process.wait.success?
          puts "Error mounting the filesystem".colorize(:red)
          return
        end
      end
    end
  end
  end
end

