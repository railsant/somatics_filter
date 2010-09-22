require 'ostruct'

module SomaticsFilter
  class Fragment < OpenStruct
    def set?
      self.is_set == '1' || self.is_set == true
    end
    alias_method :show?, :set?
  end
end