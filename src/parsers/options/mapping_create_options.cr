# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

require "option_parser"

module GX::Parsers::Options
  class MappingCreateOptions
    property type : String?
    property name : String?
    property encrypted_path : String?
    property remote_user : String?
    property remote_host : String?
    property remote_path : String?
    property remote_port : String?
    property url : String?
  end
end
