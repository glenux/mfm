module GX::Parsers
  abstract class AbstractParser
    abstract def build(parser : OptionParser, ancestors : BreadCrumbs, config : Config)
  end
end
