module SomaticsFilter
  module Helpers
    module SomaticsFilterHelper
      def somatics_filter_for(model, options = {})
        file = SomaticsFilter::Util.rails3? ? 'filter' : 'filter_rails2'
        render :file => "#{File.dirname(__FILE__)}/_#{file}.html.erb", :locals => {:somatics_filter_query => model.somatics_filter_query}
      end
    end
  end
end
