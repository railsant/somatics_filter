module SomaticsFilter
  module ActiveRecord
    module CoreExt
      def self.included(base)
        base.send :extend, ClassMethods
        base.send :include, InstanceMethods
        base.send :initialize_available_filters
      end
    end
    
    module ClassMethods
      def has_filter(field, type, options = {})
        # TODO Handling of Filter Duplication
        @@available_filters[self] ||= []
        @@available_filters[self] << (filter = SomaticsFilter::Filter.new(field, type, options))
        SomaticsFilter::Query.adapter.callback_for(filter, self)
      end

      def apply_query(params)
        query = SomaticsFilter::Query.new(params[:somatics_filter_query], self)
        self.somatics_filter_query = query
        query.execute
      end

      def available_filters
        @@available_filters[self] ||= []
      end
      
      def somatics_filter_query
        @@somatics_filter_query ||= SomaticsFilter::Query.new(nil, self)
      end

      def somatics_filter_query=(query)
        @@somatics_filter_query = query
      end
      
      # Heroku attempts to call it multiple times
      def initialize_available_filters
        @@available_filters ||= {}
      end
    end

    module InstanceMethods
    end
  end
end
