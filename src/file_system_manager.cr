# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "./models/abstract_filesystem_config"
require "./utils/fzf"

module GX
  class FileSystemManager
    Log = ::Log.for("file_system_manager")

    def initialize(@config : Config)
    end


    def mount_or_umount(selected_filesystem)
      if !selected_filesystem.mounted?
        selected_filesystem.mount
      else
        selected_filesystem.umount
      end
    end

    def auto_open(filesystem)
      # TODO: detect xdg-open presence and use it if possible
      # TODO: detect mailcap and use it if no xdg-open found
      # TODO: support user-defined command in configuration
      # TODO: detect graphical environment

      mount_point_safe = filesystem.mount_point
      raise Models::InvalidMountpointError.new("Invalid filesystem") if mount_point_safe.nil?

      if _graphical_environment?
        process = Process.new(
          "xdg-open", # # FIXME: make configurable
          [mount_point_safe],
          input: STDIN,
          output: STDOUT,
          error: STDERR
        )
        unless process.wait.success?
          puts "Error opening filesystem".colorize(:red)
          return
        end
      else
        process = Process.new(
          "vifm", # # FIXME: make configurable
          [mount_point_safe],
          input: STDIN,
          output: STDOUT,
          error: STDERR
        )
        unless process.wait.success?
          puts "Error opening filesystem".colorize(:red)
          return
        end
      end
    end

    def each(&)
      config_root = @config.root
      return if config_root.nil?

      config_root.filesystems.each do |filesystem|
        yield filesystem
      end
    end

    def filesystems
      config_root = @config.root
      return if config_root.nil?

      config_root.filesystems
    end

    # Get filesystem by name
    def detect_filesystem(filesystem_name : String) : GX::Models::AbstractFilesystemConfig?
    end

    # Choose filesystem with fzf
    def choose_filesystem : GX::Models::AbstractFilesystemConfig?
      names_display = _filesystem_table

      # FIXME: feat: allow to sort by name or by filesystem
      sorted_values = names_display.values.sort_by!(&.[:filesystem].name)
      result_filesystem_name = Utils::Fzf.run(sorted_values.map(&.[:ansi_name])).strip
      selected_filesystem = names_display[result_filesystem_name][:filesystem]
      puts ">> #{selected_filesystem.name}".colorize(:yellow)

      if !selected_filesystem
        STDERR.puts "Mapping not found: #{selected_filesystem}.".colorize(:red)
        return
      end
      selected_filesystem
    end

    private def _fzf_plain_name(filesystem : Models::AbstractFilesystemConfig) : String
      fs_str = filesystem.type.ljust(12, ' ')
      suffix = filesystem.mounted? ? "[open]" : ""
      "#{fs_str} #{filesystem.name} #{suffix}".strip
    end

    private def _fzf_ansi_name(filesystem : Models::AbstractFilesystemConfig) : String
      fs_str = filesystem.type.ljust(12, ' ').colorize(:dark_gray)
      suffix = filesystem.mounted? ? "[#{"open".colorize(:green)}]" : ""
      "#{fs_str} #{filesystem.name} #{suffix}".strip
    end

    private def _graphical_environment?
      if ENV["DISPLAY"]? || ENV["WAYLAND_DISPLAY"]?
        return true
      end
      false
    end


    alias FilesystemTableItem = 
      NamedTuple(
        filesystem: Models::AbstractFilesystemConfig,
        ansi_name: String
      )

    alias FilesystemTable = 
      Hash(
        String, 
        FilesystemTableItem
      )

    private def _filesystem_table : FilesystemTable
      names_display = {} of String => FilesystemTableItem

      config_root = @config.root
      return {} of String => FilesystemTableItem if config_root.nil?

      config_root.filesystems.each do |filesystem|
        result_name = _fzf_plain_name(filesystem)
        ansi_name = _fzf_ansi_name(filesystem)

        names_display[result_name] = {
          filesystem: filesystem,
          ansi_name:  ansi_name,
        }
      end

      names_display
    end
  end
end
