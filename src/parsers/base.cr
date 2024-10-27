# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

module GX::Parsers
  abstract class AbstractParser
    abstract def build(parser : OptionParser, ancestors : BreadCrumbs, config : Config)
  end
end
