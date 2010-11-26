module SomaticsFilter
  class SavedQuery < ::ActiveRecord::Base
    set_table_name 'somatics_filter_queries'
    serialize :search_params, Hash
    serialize :column_params, Array
    validates_presence_of :name, :query_class_name
    
    scope :of_class, lambda {|class_name| where(:query_class_name => class_name, :default => false)}
    
    def to_params
      {:search => search_params, :columns => column_params}
    end
    
    def self.default_query_of(class_name)
      find_by_query_class_name_and_default(class_name, true)
      # first(:conditions => {:query_class_name => query_class_name, :default => true})
    end
  end
end