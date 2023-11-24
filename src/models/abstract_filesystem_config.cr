# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "yaml"

module GX::Models
  class InvalidFilesystemError < Exception
  end

  class InvalidMountpointError < Exception
  end

  abstract class AbstractFilesystemConfig
    include YAML::Serializable
    # include YAML::Serializable::Strict

    use_yaml_discriminator "type", {
      gocryptfs: GoCryptFSConfig, 
      sshfs: SshFSConfig,
      httpdirfs: HttpDirFSConfig
    }

    getter type : String
    getter name : String
    property mount_point : String?

    abstract def _mount_wrapper(&block)
    abstract def _mount_action()
    abstract def _mounted_prefix()
    abstract def mounted_name()
    abstract def mounted?()
    abstract def mount()
    abstract def umount()
    abstract def mount_point?()
  end
end
