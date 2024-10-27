# SPDX-License-Identifier: GPL-3.0-or-later
#
# SPDX-FileCopyrightText: 2024 Glenn Y. Rolland <glenux@glenux.net>
# Copyright © 2024 Glenn Y. Rolland <glenux@glenux.net>

module GX::Utils
  class BreadCrumbs
    def initialize(base : Array(String))
      @ancestors = base
    end

    def +(other : String)
      BreadCrumbs.new(@ancestors + [other])
    end

    def to_s(io : IO)
      io << @ancestors.join(" ")
    end

    def to_a
      @ancestors.clone
    end
  end
end
