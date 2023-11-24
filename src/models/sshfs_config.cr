# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "shellwords"
require "./abstract_filesystem_config"
require "./concerns/base"

module GX::Models
  class SshFSConfig < AbstractFilesystemConfig
    getter remote_path : String = ""
    getter remote_user : String = ""
    getter remote_host : String = ""
    getter remote_port : String = "22"

    include Concerns::Base

    def _mounted_prefix()
      "#{@remote_user}@#{@remote_host}:#{@remote_path}"
    end

    def mounted_name()
      @name
    end

    def _mount_action()
      mount_point_safe = @mount_point
      raise InvalidMountpointError.new("Invalid mount point") if mount_point_safe.nil?

      process = Process.new(
        "sshfs", 
        [
          "-p", remote_port,
          "#{@remote_user}@#{@remote_host}:#{@remote_path}", 
          mount_point_safe
        ], 
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
