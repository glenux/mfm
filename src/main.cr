require "yaml"
require "colorize"
require "json"

require "./filesystems/gocryptfs"
require "./config"
require "./cli"

app = GX::Cli.new
app.parse_command_line(ARGV)
app.run


