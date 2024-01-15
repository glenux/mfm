require "./base.cr"
require "../utils/parser_lines"

module GX::Parsers
  class MappingParser < AbstractParser
    def build(parser, ancestors, config)
      breadcrumbs = ancestors + "mapping"
      add_args = {name: "", path: ""}
      delete_args = {name: ""}

      parser.banner = Utils.usage_line(
        breadcrumbs,
        "Manage FUSE filesystem mappings",
        true
      )
      parser.separator("\nCommands")

      parser.on("list", "List mappings") do
        config.mode = Types::Mode::MappingList
        parser.separator(Utils.help_line(breadcrumbs + "list"))
        # abort("FIXME: Not implemented")
      end

      parser.on("create", "Create mapping") do
        config.mode = Types::Mode::MappingCreate
        # pp parser
        parser.banner = Utils.usage_line(breadcrumbs + "create", "Create mapping", true)
        parser.separator("\nCreate options")

        parser.on("-t", "--type TYPE", "Set filesystem type") do |type|
          add_args = add_args.merge({type: type})
        end

        parser.on("-n", "--name", "Set mapping name") do |name|
          add_args = add_args.merge({name: name})
        end

        parser.on("-p", "--path", "Set mapping encrypted path") do |path|
          add_args = add_args.merge({path: path})
        end
        parser.separator(Utils.help_line(breadcrumbs + "create"))
      end

      parser.on("edit", "Edit configuration") do |_|
        config.mode = Types::Mode::MappingEdit
        parser.separator(Utils.help_line(breadcrumbs + "edit"))
        # abort("FIXME: Not implemented")
      end

      parser.on("mount", "Mount mapping") do |_|
        config.mode = Types::Mode::MappingMount
        parser.separator(Utils.help_line(breadcrumbs + "mount"))
        # abort("FIXME: Not implemented")
      end

      parser.on("umount", "Umount mapping") do |_|
        config.mode = Types::Mode::MappingUmount
        parser.separator(Utils.help_line(breadcrumbs + "umount"))
        # abort("FIXME: Not implemented")
      end

      parser.on("delete", "Delete mapping") do
        config.mode = Types::Mode::MappingDelete

        parser.banner = Utils.usage_line(breadcrumbs + "delete", "Delete mapping", true)
        parser.separator("\nDelete options")

        parser.on("-n", "--name", "Set mapping name") do |name|
          delete_args = delete_args.merge({name: name})
        end
        parser.separator(Utils.help_line(breadcrumbs + "delete"))
      end

      parser.separator Utils.help_line(breadcrumbs)
    end
  end
end
