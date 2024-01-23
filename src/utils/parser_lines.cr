require "./breadcrumbs"

module GX::Utils
  def self.usage_line(breadcrumbs : BreadCrumbs, description : String, has_commands : Bool = false)
    [
      "Usage: #{breadcrumbs}#{has_commands ? " [commands]" : ""} [options]",
      "",
      description,
      "",
      "Global options:",
    ].join("\n")
  end

  def self.help_line(breadcrumbs : BreadCrumbs)
    "\nRun '#{breadcrumbs} COMMAND --help' for more information on a command."
  end
end
