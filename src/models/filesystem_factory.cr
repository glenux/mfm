# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

module GX::Models
  class FilesystemFactory
    def self.build(create_options)
      case create_options.type
      when "gocryptfs"
        GoCryptFSConfig.new(create_options)
      when "sshfs"
        SshFSConfig.new(create_options)
      when "httpdirfs"
        HttpDirFSConfig.new(create_options)
      else
        raise ArgumentError.new("Unsupported mapping type: #{create_options.type}")
      end
    end
  end
end
