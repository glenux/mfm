# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "shellwords"
require "./abstract_filesystem_config"
require "./concerns/base"

module GX::Models
  class GoCryptFSConfig < AbstractFilesystemConfig
    getter encrypted_path : String = ""

    include Concerns::Base

    def _mounted_prefix()
      "#{encrypted_path}"
    end

    def mounted_name()
      "#{@name}.Open"
    end

    def _mount_action()
      mount_point_safe = @mount_point
      raise InvalidMountpointError.new("Invalid mount point") if mount_point_safe.nil?

      process = Process.new(
        "gocryptfs", 
        ["-idle", "15m", @encrypted_path, mount_point_safe], 
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
