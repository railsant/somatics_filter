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
      SomaticsFilter::Adapters::SearchlogicAdapter.search(self)
    end
    
    def not_set_fragments
      @fragments.reject {|field_name, fragment| fragment.show? }
    end

    private
    
    # Initialize Query object with search params from form and model
    # @fragments is used for form rendering and query conversion for backend search engine (e.g. searchlogic)
    def initialize(search_params, model)
      @search_params = search_params || {}
      @model = model
      
      # Always initial fragments for filter by using available filters of model
      # FIXME Ordering of Fragments
      @fragments = @model.available_filters.inject({}) {|h, filter| h[filter.field_name] = SomaticsFilter::Fragment.new(filter.to_fragment); h}
      @search_params.each do |field_name, options|
        next unless @fragments[field_name]
        @fragments[field_name].is_set = options['is_set']
        @fragments[field_name].operator = options['operator']
        @fragments[field_name].value = options['value']
      end
    end
  end
end