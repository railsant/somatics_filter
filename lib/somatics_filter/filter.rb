module SomaticsFilter
  class Filter
    attr_reader :field, :type, :options
    
    def to_fragment
      {'is_set' => self.is_default? ? '1' : '0', 'operator' => self.available_operators.first, 'value' => '', 'filter' => self}
    end

    def is_default?
      !!@options[:default]
    end
    
    def order
      @options[:order] || 999
    end
    
    def field_name
      @field.to_s
    end
    
    # TODO Should return according to adapter in use
    def value_field(form_object)
      SomaticsFilter::Adapters::SearchlogicAdapter.input_field_of_filter(self, form_object)
    end
    
    # TODO Should return according to adapter in use
    def available_operators
      SomaticsFilter::Adapters::SearchlogicAdapter.available_operators_of_filter_type(@type)
    end
    
    private

    def initialize(field, type, options = {})
      @field = field
      @type  = type
      @options = options
    end
  end
end