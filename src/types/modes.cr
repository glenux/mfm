# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

module GX::Types
  enum Mode
    None

    GlobalVersion
    GlobalHelp
    GlobalCompletion
    GlobalTui
    GlobalConfig
    # GlobalMapping

    ConfigInit

    MappingCreate
    MappingDelete
    MappingEdit
    MappingList
    MappingMount
    MappingUmount
  end
end
