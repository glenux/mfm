# require "./models/abstract_filesystem_config"
require "./utils/fzf"

module GX
  class FileSystemManager
    Log = ::Log.for("file_system_manager")

    def initialize(@config : Config)
    end

    # OBSOLETE:
    # def mount_filesystem(filesystem : Models::AbstractFilesystemConfig)
    #   raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?
    #   if filesystem.mounted?
    #     Log.info { "Filesystem already mounted." }
    #     return
    #   end
    #   filesystem.mount
    # end

    # OBSOLETE:
    # def umount_filesystem(filesystem : Models::AbstractFilesystemConfig)
    #   raise Models::InvalidFilesystemError.new("Invalid filesystem") if filesystem.nil?
    #   unless filesystem.mounted?
    #     Log.info { "Filesystem is not mounted." }
    #     return
    #   end
    #   filesystem.umount
    # end

    def mount_or_umount(selected_filesystem)
      if !selected_filesystem.mounted?
        selected_filesystem.mount
      else
        selected_filesystem.umount
      end
    end

    def auto_open(filesystem)
      # FIXME: detect xdg-open and use it if possible
      # FIXME: detect mailcap and use it if no xdg-open found
      # FIXME: support user-defined command in configuration
      # FIXME: detect graphical environment

      mount_point_safe = filesystem.mount_point
      raise Models::InvalidMountpointError.new("Invalid filesystem") if mount_point_safe.nil?

      if graphical_environment?
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

    def choose_filesystem
      names_display = {} of String => NamedTuple(filesystem: Models::AbstractFilesystemConfig, ansi_name: String)

      config_root = @config.root
      return if config_root.nil?

      config_root.filesystems.each do |filesystem|
        fs_str = filesystem.type.ljust(12, ' ')

        suffix = ""
        suffix_ansi = ""
        if filesystem.mounted?
          suffix = "[open]"
          suffix_ansi = "[#{"open".colorize(:green)}]"
        end

        result_name = "#{fs_str} #{filesystem.name} #{suffix}".strip
        ansi_name = "#{fs_str.colorize(:dark_gray)} #{filesystem.name} #{suffix_ansi}".strip

        names_display[result_name] = {
          filesystem: filesystem,
          ansi_name:  ansi_name,
        }
      end

      # # FIXME: feat: allow to sort by name or by filesystem
      sorted_values = names_display.values.sort_by { |item| item[:filesystem].name }
      result_filesystem_name = Utils::Fzf.run(sorted_values.map(&.[:ansi_name])).strip
      selected_filesystem = names_display[result_filesystem_name][:filesystem]
      puts ">> #{selected_filesystem.name}".colorize(:yellow)

      if !selected_filesystem
        STDERR.puts "Mapping not found: #{selected_filesystem}.".colorize(:red)
        return
      end
      return selected_filesystem
    end

    private def generate_display_name(filesystem : Models::AbstractFilesystemConfig) : String
      fs_str = filesystem.type.ljust(12, ' ')
      suffix = filesystem.mounted? ? "[open]" : ""
      "#{fs_str} #{filesystem.name} #{suffix}".strip
    end

    private def graphical_environment?
      if ENV["DISPLAY"]? || ENV["WAYLAND_DISPLAY"]?
        return true
      end
      return false
    end
  end
end
