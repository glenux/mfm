module GX
class Vault
  getter name : String
  getter encrypted_path : String
  getter mount_dir : String

  def initialize(@name, @encrypted_path, mount_name : String)
    home_dir = ENV["HOME"] || raise "Home directory not found"
    @mount_dir = File.join(home_dir, "mnt/#{mount_name}")
  end

  def mounted? : Bool
    `mount`.includes?("#{encrypted_path} on #{mount_dir}")
  end

  def mount
    Dir.mkdir_p(mount_dir) unless Dir.exists?(mount_dir)

    if mounted?
      puts "Already mounted. Skipping.".colorize(:yellow)
    else
      input = STDIN
      output = STDOUT
      error = STDERR
      process = Process.new("gocryptfs", ["-idle", "15m", encrypted_path, mount_dir], input: input, output: output, error: error)
      unless process.wait.success?
        puts "Error mounting the vault".colorize(:red)
        return
      end
      puts "Vault #{name} is now available on #{mount_dir}".colorize(:green)
    end
  end
  def unmount
    `fusermount -u #{mount_dir}`
    puts "Vault #{name} is now closed.".colorize(:green)
  end
end
end
