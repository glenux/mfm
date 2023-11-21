# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "yaml"

module GX
  module Filesystem
    abstract class AbstractFilesystem
      include YAML::Serializable

      use_yaml_discriminator "type", {
        gocryptfs: GoCryptFS, 
        sshfs: SshFS,
        httpdirfs: HttpDirFS
      }

      property type : String

      abstract def mount()
      abstract def unmount()
      abstract def mounted_prefix()
    end
  end
end

