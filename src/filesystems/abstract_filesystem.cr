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
    end

    module FilesystemBase
      def unmount
        system("fusermount -u #{mount_dir.shellescape}")
        fusermount_status = $?

        if fusermount_status.success?
          puts "Filesystem #{name} is now closed.".colorize(:green)
        else
          puts "Error: Unable to unmount filesystem #{name} (exit code: #{fusermount_status.exit_code}).".colorize(:red)
        end
      end

      def mount(&block)
        Dir.mkdir_p(mount_dir) unless Dir.exists?(mount_dir)
        if mounted?
          puts "Already mounted. Skipping.".colorize(:yellow)
          return
        end

        yield

        puts "Filesystem #{name} is now available on #{mount_dir}".colorize(:green)
      end
    end
  end
end

require "./gocryptfs"
require "./sshfs"
