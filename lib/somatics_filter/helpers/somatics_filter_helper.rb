module SomaticsFilter
  module Helpers
    module SomaticsFilterHelper
      def somatics_filter_for(model, options = {})
        render :file => "#{File.dirname(__FILE__)}/_filter.html.erb", :locals => {:somatics_filter_query => model.somatics_filter_query}
      end
    end
  end
end