module GX::Utils
  class BreadCrumbs
    def initialize(base : Array(String))
      @ancestors = base
    end

    def +(elem : String)
      b = BreadCrumbs.new(@ancestors + [elem])
    end

    def to_s
      @ancestors.join(" ")
    end

    def to_a
      @ancestors.clone
    end
  end
end
