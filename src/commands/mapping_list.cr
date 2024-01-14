require "./abstract_command"
require "../file_system_manager"
require "tablo"

module GX::Commands
  class MappingList < AbstractCommand
    def initialize(@config : GX::Config)
      @config.load_from_env
      @config.load_from_file
      @file_system_manager = FileSystemManager.new(@config)
    end

    def execute
      filesystems = @config.root.try &.filesystems
      return if filesystems.nil?
      # pp filesystems

      fsdata = [] of Array(String)
      filesystems.each do |item|
        fsdata << [
          item.type,
          item.name,
          item.mounted?.to_s,
        ]
      end
      # pp fsdata

      report = Tablo::Table.new(
        fsdata,
        # connectors: Tablo::CONNECTORS_SINGLE_ROUNDED
        column_padding: 0,
        style: "" # Tablo::STYLE_NO_MID_COL
) do |table|
        table.add_column("TYPE") { |row| row[0] }
        table.add_column("NAME", width: 40) { |row| row[1] }
        table.add_column("MOUNTED") { |row| row[2] }
      end
      puts report
    end

    def self.handles_mode
      GX::Types::Mode::MappingList
    end
  end
end
