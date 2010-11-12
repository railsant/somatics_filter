module SomaticsFilter
  module Helpers
    module SomaticsFilterHelper
      def somatics_filter_for(model_name, options = {})
        model = model_name.to_s.camelize.constantize
        file = SomaticsFilter::Util.rails3? ? 'filter' : 'filter_rails2'
        render :file => "#{File.dirname(__FILE__)}/_#{file}.html.erb", :locals => {:somatics_filter_query => model.somatics_filter_query}
      end
      
      def somatics_queries_of(model_name, options = {})
        class_name = model_name.to_s.camelize
        render :file => "#{File.dirname(__FILE__)}/_queries.html.erb", :locals => {:queries => SomaticsFilter::SavedQuery.of_class(class_name)}
      end
    end
  end
end
