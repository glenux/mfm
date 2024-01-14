# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2023 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2023 Glenn Y. Rolland <glenux@glenux.net>

require "yaml"
require "./abstract_filesystem_config"

module GX::Models
  class InvalidEnvironmentError < Exception
  end

  class GlobalConfig
    include YAML::Serializable
    include YAML::Serializable::Strict

    @[YAML::Field(key: "mount_point_base")]
    getter mount_point_base : String?

    def after_initialize
      raise InvalidEnvironmentError.new("Home directory not found") if !ENV["HOME"]?
      home_dir = ENV["HOME"]

      # Set default mountpoint from global if none defined
      if @mount_point_base.nil? || @mount_point_base.try &.empty?
        @mount_point_base = File.join(home_dir, "mnt")
      end
    end
  end
end
