require 'somatics_filter/active_record/core_ext'
require 'somatics_filter/helpers/somatics_filter_helper'

ActiveRecord::Base.send :include, SomaticsFilter::ActiveRecord::CoreExt
ActionController::Base.send :helper, SomaticsFilter::Helpers::SomaticsFilterHelper

I18n.load_path += Dir[File.expand_path(File.dirname(__FILE__) + '/../config/locales/*.yml')]

# Use MetaSearch for Rails 3
SomaticsFilter::Query.adapter = :meta_search if Rails.versions.starts_with('3')