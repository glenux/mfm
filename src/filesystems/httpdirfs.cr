require "shellwords"
require "./filesystem"

module GX
  class HttpDirFS < Filesystem
    getter name : String = ""
    getter url : String = ""

    @[YAML::Field(key: "mount_dir", ignore: true)]
    getter mount_dir : String = ""

    include GenericFilesystem

    def after_initialize()
      home_dir = ENV["HOME"] || raise "Home directory not found"
      @mount_dir = File.join(home_dir, "mnt/#{@name}")
    end

    def mounted? : Bool
      `mount`.includes?("httpdirfs on #{mount_dir}")
    end

    def mount
      super do
        input = STDIN
        output = STDOUT
        error = STDERR
        process = Process.new(
          "httpdirfs", 
          ["#{url}", mount_dir], 
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

