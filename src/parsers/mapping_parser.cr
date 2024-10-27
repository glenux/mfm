# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./base.cr"
require "../utils/parser_lines"

module GX::Parsers
  class MappingParser < AbstractParser
    def build(parser, ancestors, config)
      breadcrumbs = ancestors + "mapping"
      delete_args = {name: ""}
      mount_args = {name: ""}
      umount_args = {name: ""}

      parser.banner = Utils.usage_line(
        breadcrumbs,
        "Manage FUSE filesystem mappings",
        true
      )
      parser.separator("\nCommands")

      parser.on("list", "List mappings") do
        config.mode = Types::Mode::MappingList
        parser.separator(Utils.help_line(breadcrumbs + "list"))
      end

      parser.on("create", "Create mapping") do
        config.mode = Types::Mode::MappingCreate
        config.mode = Types::Mode::MappingCreate
        config.mapping_create_options = Parsers::Options::MappingCreateOptions.new

        parser.banner = Utils.usage_line(breadcrumbs + "create", "Create mapping", true)
        parser.separator("\nCreate options")

        parser.on("-t", "--type TYPE", "Set filesystem type") do |type|
          config.mapping_create_options.try do |opts|
            opts.type = type
          end
        end
        parser.on("-n", "--name NAME", "Set mapping name") do |name|
          config.mapping_create_options.try do |opts|
            opts.name = name
          end
        end

        # Filesystem specific
        parser.on("--encrypted-path PATH", "Set encrypted path (for gocryptfs)") do |path|
          config.mapping_create_options.try do |opts|
            opts.encrypted_path = path
          end
        end
        parser.on("--remote-user USER", "Set SSH user (for sshfs)") do |user|
          config.mapping_create_options.try do |opts|
            opts.remote_user = user
          end
        end
        parser.on("--remote-host HOST", "Set SSH host (for sshfs)") do |host|
          config.mapping_create_options.try do |opts|
            opts.remote_host = host
          end
        end
        parser.on("--source-path PATH", "Set remote path (for sshfs)") do |path|
          config.mapping_create_options.try do |opts|
            opts.remote_path = path
          end
        end
        parser.on("--remote-port PORT", "Set SSH port (for sshfs)") do |port|
          config.mapping_create_options.try do |opts|
            opts.remote_port = port
          end
        end
        parser.on("--url URL", "Set URL (for httpdirfs)") do |url|
          config.mapping_create_options.try do |opts|
            opts.url = url
          end
        end

        parser.separator(Utils.help_line(breadcrumbs + "create"))
      end

      parser.on("edit", "Edit configuration") do |_|
        config.mode = Types::Mode::MappingEdit

        parser.on("--remote-user USER", "Set SSH user") do |user|
          config.mapping_create_options.try do |opts|
            opts.remote_user = user
          end
        end
        parser.on("--remote-host HOST", "Set SSH host") do |host|
          config.mapping_create_options.try do |opts|
            opts.remote_host = host
          end
        end
        parser.on("--source-path PATH", "Set remote path") do |path|
          config.mapping_create_options.try do |opts|
            opts.remote_path = path
          end
        end

        parser.separator(Utils.help_line(breadcrumbs + "edit"))
        # abort("FIXME: Not implemented")
      end

      parser.on("mount", "Mount mapping") do |_|
        config.mode = Types::Mode::MappingMount

        parser.banner = Utils.usage_line(breadcrumbs + "mount", "mount mapping", true)
        parser.separator("\nMount options")

        parser.on("-n", "--name", "Set mapping name") do |name|
          mount_args = mount_args.merge({name: name})
        end

        parser.separator(Utils.help_line(breadcrumbs + "mount"))
      end

      parser.on("umount", "Umount mapping") do |_|
        config.mode = Types::Mode::MappingUmount

        parser.banner = Utils.usage_line(breadcrumbs + "umount", "umount mapping", true)
        parser.separator("\nUmount options")

        parser.on("-n", "--name", "Set mapping name") do |name|
          umount_args = umount_args.merge({name: name})
        end

        parser.separator(Utils.help_line(breadcrumbs + "umount"))
      end

      parser.on("delete", "Delete mapping") do
        config.mode = Types::Mode::MappingDelete

        parser.banner = Utils.usage_line(breadcrumbs + "delete", "delete mapping", true)
        parser.separator("\ndelete options")

        parser.on("-n", "--name", "Set mapping name") do |name|
          delete_args = delete_args.merge({name: name})
        end
        parser.separator(Utils.help_line(breadcrumbs + "delete"))
      end

      parser.separator Utils.help_line(breadcrumbs)
    end
  end
end
