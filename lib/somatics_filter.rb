require 'somatics_filter/active_record/core_ext'
require 'somatics_filter/helpers/somatics_filter_helper'

ActiveRecord::Base.send :include, SomaticsFilter::ActiveRecord::CoreExt
ActionController::Base.helper SomaticsFilter::Helpers::SomaticsFilterHelper