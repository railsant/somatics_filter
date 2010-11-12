module SomaticsFilter
  class SavedQuery < ::ActiveRecord::Base
    set_table_name 'somatics_filter_queries'
    serialize :search_params, Hash
    serialize :column_params, Array
    validates_presence_of :name, :query_class_name, :search_params, :column_params
    
    scope :of_class, lambda {|class_name| where(:query_class_name => class_name)}
    
    def to_params
      {:search => search_params, :columns => column_params}
    end
  end
end