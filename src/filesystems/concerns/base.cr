
module GX::Filesystem::Concerns
  module Base
    def after_initialize()
      home_dir = ENV["HOME"] || raise "Home directory not found"

      # Use default mountpoint if none defined
      if @mount_dir.empty?
        @mount_dir = File.join(home_dir, "mnt/#{@name}")
      end
    end

    def mounted? : Bool
      `mount`.includes?(" on #{mount_dir} type ")
    end

    def unmount : Nil
      system("fusermount -u #{mount_dir.shellescape}")
      fusermount_status = $?

      if fusermount_status.success?
        puts "Filesystem #{name} is now closed.".colorize(:green)
      else
        puts "Error: Unable to unmount filesystem #{name} (exit code: #{fusermount_status.exit_code}).".colorize(:red)
      end
    end

    def _mount_wrapper(&block) : Nil
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
