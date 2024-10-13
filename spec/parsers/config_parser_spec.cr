require "../spec_helper"
require "../../src/parsers/config_parser"

describe GX::Parsers::ConfigParser do
  context "Initialization" do
    it "can initialize" do
      GX::Parsers::ConfigParser.new.should be_a(GX::Parsers::ConfigParser)
    end
  end

  context "Functioning" do
    it "can parse 'init' subcommand" do
      config = GX::Config.new
      parser = OptionParser.new
      breadcrumbs = GX::Utils::BreadCrumbs.new(["mfm"])

      GX::Parsers::ConfigParser.new.build(parser, breadcrumbs, config)

      # Test 'init' subcommand recognition
      config.mode.should eq(GX::Types::Mode::GlobalTui) # default
      parser.parse(["init"])
      config.mode.should eq(GX::Types::Mode::ConfigInit)

      # Test ConfigInitOptions instantiation
      config.config_init_options.should be_a(GX::Parsers::Options::ConfigInitOptions)

      # Test banner update
      # FIXME: parser.banner.should include("Create initial mfm configuration")

      # Test separator presence
      # FIXME: parser.banner.should include("Init options")
    end

    it "can parse '-p' / '--path' option for 'init' subcommand" do
      config = GX::Config.new
      parser = OptionParser.new
      breadcrumbs = GX::Utils::BreadCrumbs.new(["mfm"])

      GX::Parsers::ConfigParser.new.build(parser, breadcrumbs, config)
      parser.parse(["init", "-p", "/test/path"])
      pp config
      config.config_init_options.try do |opts|
        opts.path.should eq("/test/path")
      end

      config = GX::Config.new
      parser = OptionParser.new
      breadcrumbs = GX::Utils::BreadCrumbs.new(["mfm"])

      GX::Parsers::ConfigParser.new.build(parser, breadcrumbs, config)
      parser.parse(["init", "--path", "/test/path/2"])
      config.config_init_options.try do |opts|
        opts.path.should eq("/test/path/2")
      end
    end

    it "should include help line for 'init' subcommand" do
      config = GX::Config.new
      parser = OptionParser.new
      breadcrumbs = GX::Utils::BreadCrumbs.new(["mfm"])

      GX::Parsers::ConfigParser.new.build(parser, breadcrumbs, config)

      # Test help line presence
      # FIXME: parser.banner.should include("Run 'mfm config init --help' for more information on a command.")
    end
  end
end
