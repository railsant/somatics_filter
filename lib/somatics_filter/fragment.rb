require 'ostruct'

module SomaticsFilter
  class Fragment < OpenStruct
    def is_set
      send(SomaticsFilter::Query::ParamNames[:is_set])
    end
    def is_set=(value)
      send("#{SomaticsFilter::Query::ParamNames[:is_set].to_s}=", value)
    end
    
    def operator
      send(SomaticsFilter::Query::ParamNames[:operator])
    end
    def operator=(value)
      send("#{SomaticsFilter::Query::ParamNames[:operator].to_s}=", value)
    end
    
    def value
      send(SomaticsFilter::Query::ParamNames[:value])
    end
    def value=(value)
      send("#{SomaticsFilter::Query::ParamNames[:value].to_s}=", value)
    end
    
    def value1
      send(SomaticsFilter::Query::ParamNames[:value1])
    end
    def value1=(value)
      send("#{SomaticsFilter::Query::ParamNames[:value1].to_s}=", value)
    end
    
    def value2
      send(SomaticsFilter::Query::ParamNames[:value2])
    end
    def value2=(value)
      send("#{SomaticsFilter::Query::ParamNames[:value2].to_s}=", value)
    end
    
    def set?
      self.is_set == '1' || self.is_set == true
    end
    alias_method :show?, :set?
  end
end