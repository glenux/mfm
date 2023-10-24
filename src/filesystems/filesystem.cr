

require "yaml"

module GX
  abstract class Filesystem
    include YAML::Serializable

    use_yaml_discriminator "type", {
      gocryptfs: GoCryptFS, 
      sshfs: SshFS
    }

    property type : String
  end

  module GenericFilesystem
    def unmount
      system("fusermount -u #{mount_dir.shellescape}")
      puts "Filesystem #{name} is now closed.".colorize(:green)
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

require "./gocryptfs"
require "./sshfs"
