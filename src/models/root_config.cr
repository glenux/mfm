# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "yaml"
require "./abstract_filesystem_config"
require "./global_config"

module GX::Models
  # class CrinjaConverter
  #   def self.from_yaml(ctx : YAML::ParseContext , node : YAML::Nodes::Node)
  #     l_node = node
  #     if l_node.is_a?(YAML::Nodes::Scalar)
  #       value_patched = Crinja.render(l_node.value, {"env" => ENV.to_h})
  #       return value_patched
  #     end

  #     return "<null>"
  #   end
  #
  #   def self.to_yaml(value, builder : YAML::Nodes::Builder)
  #   end
  # end

  class RootConfig
    include YAML::Serializable
    include YAML::Serializable::Strict

    # @[YAML::Field(key: "version", converter: GX::Models::CrinjaConverter)]
    @[YAML::Field(key: "version")]
    getter version : String

    @[YAML::Field(key: "global")]
    getter global : GlobalConfig

    @[YAML::Field(key: "filesystems")]
    getter filesystems : Array(AbstractFilesystemConfig)
  end
end
