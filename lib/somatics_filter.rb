require 'somatics_filter/active_record/core_ext'
require 'somatics_filter/helpers/somatics_filter_helper'

module SomaticsFilter
  module Util
    def self.rails3?
      Rails.version.starts_with?('3')
    end
  end
end

ActiveRecord::Base.send :include, SomaticsFilter::ActiveRecord::CoreExt
ActionController::Base.send :helper, SomaticsFilter::Helpers::SomaticsFilterHelper

I18n.load_path += Dir[File.expand_path(File.dirname(__FILE__) + '/../config/locales/*.yml')]

# Use MetaSearch for Rails 3
SomaticsFilter::Query.adapter = :meta_search if SomaticsFilter::Util.rails3?
