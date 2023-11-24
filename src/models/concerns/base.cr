
module GX::Models::Concerns
  module Base
    def mounted?() : Bool
      mount_point_safe = @mount_point
      raise InvalidMountpointError.new("Invalid mountpoint value") if mount_point_safe.nil?

      `mount`.includes?(" on #{mount_point_safe} type ")
    end

    def umount() : Nil
      mount_point_safe = @mount_point
      raise InvalidMountpointError.new("Invalid mountpoint value") if mount_point_safe.nil?

      system("fusermount -u #{mount_point_safe.shellescape}")
      fusermount_status = $?

      if fusermount_status.success?
        puts "Models #{name} is now closed.".colorize(:green)
      else
        puts "Error: Unable to unmount filesystem #{name} (exit code: #{fusermount_status.exit_code}).".colorize(:red)
      end
    end

    def mount_point?()
      !mount_point.nil?
    end

    def mount()
      _mount_wrapper() do
        _mount_action
      end
    end

    def _mount_wrapper(&block) : Nil
      mount_point_safe = mount_point
      return if mount_point_safe.nil?

      Dir.mkdir_p(mount_point_safe) unless Dir.exists?(mount_point_safe)
      if mounted?
        puts "Already mounted. Skipping.".colorize(:yellow)
        return
      end

      result_status = yield

      if result_status.success?
        puts "Models #{name} is now available on #{mount_point_safe}".colorize(:green)
      else
        puts "Error mounting the vault".colorize(:red)
        return
      end
    end
  end

end
