module SomaticsFilter
  class Query
    ParamNames = {
      :filter  => :f,
      :search  => :s,
      :columns => :c,
      :is_set  => :is,
      :operator => :o,
      :value => :v,
      :value1 => :v1,
      :value2 => :v2
    }

    attr_reader :fragments, :model, :available_columns, :selected_columns
    
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
    
    def columns_selected?
      !@selected_columns.empty?
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
        SomaticsFilter::Adapters::MetaSearchAdapter
      else
      end
    end

    private
    
    # Initialize Query object with search params and column params from form and model
    # @fragments is used for form rendering and query conversion for backend search engine (e.g. meta_search)
    def initialize(params, model)
      key = SomaticsFilter::Query::ParamNames[:filter]
      search_key = SomaticsFilter::Query::ParamNames[:search]
      columns_key = SomaticsFilter::Query::ParamNames[:columns]

      @model = model      
      if params[key] && params[key].is_a?(String) && (saved_query = SomaticsFilter::SavedQuery.find_by_id(params[key].to_i))
        if params[:_delete]
          saved_query.destroy
        else
          @search_params = saved_query.search_params
          @column_params = saved_query.column_params
        end
      else
        @search_params = (params[key][search_key] rescue {})
        @column_params = (params[key][columns_key] rescue [])
        if default_query = SomaticsFilter::SavedQuery.default_query_of(@model.model_name.to_s)
          @search_params = default_query.search_params if @search_params.blank?
          @column_params = default_query.column_params if @column_params.blank?
        end
      end
      
      # Always initial fragments for filter by using available filters of model
      @fragments = @model.available_filters.inject({}) {|h, filter| h[filter.field_name] = filter.to_fragment; h}
      @search_params ||= {}
      @search_params.each do |field_name, options|
        next unless @fragments[field_name]
        @fragments[field_name].is_set   = options[SomaticsFilter::Query::ParamNames[:is_set]]
        @fragments[field_name].operator = options[SomaticsFilter::Query::ParamNames[:operator]]
        @fragments[field_name].value    = options[SomaticsFilter::Query::ParamNames[:value]]
        @fragments[field_name].value1   = options[SomaticsFilter::Query::ParamNames[:value1]]
        @fragments[field_name].value2   = options[SomaticsFilter::Query::ParamNames[:value2]]
      end
      
      @column_params ||= []
      @available_columns = @model.available_columns - @column_params
      @selected_columns = @column_params
      
      if params[key] && !params[key][:save].blank?
        if params[key][:save][:default] && (default_query = SomaticsFilter::SavedQuery.default_query_of(@model.model_name.to_s))
          default_query.update_attributes({
            :search_params => @search_params,
            :column_params => @column_params
          })
        else
          SomaticsFilter::SavedQuery.create({
            :name => params[key][:save][:name] || 'Default',
            :default => !!params[key][:save][:default],
            :query_class_name => @model.model_name.to_s,
            :search_params => @search_params,
            :column_params => @column_params
          })
        end
      end
    end
  end
end
