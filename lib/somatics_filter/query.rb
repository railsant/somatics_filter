module SomaticsFilter
  class Query
    attr_reader :fragments, :model
    
    def each_fragment
      sorted_fragments = @fragments.sort_by {|field_name, fragment| fragment.filter.order}
      sorted_fragments.each do |field_name, fragment|
        yield field_name, fragment
      end
    end

    def execute
      self.adapter.search(self)
    end
    
    def not_set_fragments
      @fragments.reject {|field_name, fragment| fragment.show? }
    end
    
    def adapter
      Query.adapter
    end
    
    def self.adapter
      @@adapter ||= SomaticsFilter::Adapters::SearchlogicAdapter
    end
    
    def self.adapter=(adapter)
      @@adapter = case adapter
      when :searchlogic, :search_logic
        SomaticsFilter::Adapters::SearchlogicAdapter
      when :metasearch, :meta_search
      else
      end
    end

    private
    
    # Initialize Query object with search params from form and model
    # @fragments is used for form rendering and query conversion for backend search engine (e.g. searchlogic)
    def initialize(search_params, model)
      @search_params = search_params || {}
      @model = model
      
      # Always initial fragments for filter by using available filters of model
      @fragments = @model.available_filters.inject({}) {|h, filter| h[filter.field_name] = SomaticsFilter::Fragment.new(filter.to_fragment); h}
      @search_params.each do |field_name, options|
        next unless @fragments[field_name]
        @fragments[field_name].is_set = options['is_set']
        @fragments[field_name].operator = options['operator']
        @fragments[field_name].value = options['value']
        @fragments[field_name].value1 = options['value1']
        @fragments[field_name].value2 = options['value2']
      end
    end
  end
end