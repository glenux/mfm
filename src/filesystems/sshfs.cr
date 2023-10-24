require "shellwords"
require "./filesystem"

module GX
  class SshFS < Filesystem
    getter name : String = ""
    getter remote_path : String = ""
    getter remote_user : String = ""
    getter remote_host : String = ""

    @[YAML::Field(key: "mount_dir", ignore: true)]
    getter mount_dir : String = ""

    include GenericFilesystem

    def after_initialize()
      home_dir = ENV["HOME"] || raise "Home directory not found"
      @mount_dir = File.join(home_dir, "mnt/#{@name}")
    end

    def mounted? : Bool
      `mount`.includes?("#{remote_user}@#{remote_host}:#{remote_path} on #{mount_dir}")
    end

    def mount
      super do
        input = STDIN
        output = STDOUT
        error = STDERR
        process = Process.new(
          "sshfs", 
          ["#{remote_user}@#{remote_host}:#{remote_path}", mount_dir], 
          input: input, 
          output: output, 
          error: error
        )
        unless process.wait.success?
          puts "Error mounting the filesystem".colorize(:red)
          return
        end
      end
    end
  end
end
