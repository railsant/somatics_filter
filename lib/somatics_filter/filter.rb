module SomaticsFilter
  class Filter
    attr_reader :field, :type, :options
    
    # FIXME value1 and value2 are specific fields that are required by some filter type, not all contain these values
    def to_fragment
      {'is_set' => self.is_default? ? '1' : '0', 'operator' => self.default_operator, 'value' => self.default_value, 'value1' => self.default_value, 'value2' => self.default_value, 'filter' => self}
    end
    

    def is_default?
      !!@options[:default]
    end
    
    def default_operator
      @options[:default_operator] || self.available_operators.first
    end
    
    def default_value
      @options[:default_value] || ''
    end

    def order
      @options[:order] || 999
    end
    
    def field_name
      @field.to_s
    end
    
    # TODO Should return according to adapter in use
    def value_field(form_object)
      SomaticsFilter::Query.adapter.input_field_of_filter(self, form_object)
    end
    
    # TODO Should return according to adapter in use
    def available_operators
      SomaticsFilter::Query.adapter.available_operators_of_filter_type(@type)
    end
    
    private

    def initialize(field, type, options = {})
      @field = field
      @type  = type
      @options = options
    end
  end
end