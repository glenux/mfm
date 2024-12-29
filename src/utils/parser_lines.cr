require "./breadcrumbs"

module GX::Utils
  def self.usage_line(breadcrumbs : BreadCrumbs, description : String, has_commands : Bool = false)
    [
      "Usage: #{breadcrumbs.to_s}#{has_commands ? " [commands]" : ""} [options]",
      "",
      description,
      "",
      "Global options:",
    ].join("\n")
  end

  def self.help_line(breadcrumbs : BreadCrumbs)
    "\nRun '#{breadcrumbs.to_s} COMMAND --help' for more information on a command."
  end
end
