module SomaticsFilter
  module ActionController
    module CoreExt
      def self.included(base)
        base.send :extend, ClassMethods
        base.send :include, InstanceMethods
        base.before_filter :handle_somatics_filter_query
      end
      
      module ClassMethods
      end
      
      module InstanceMethods
        protected

        # Prepare Query Statements for Model, which can be loaded from two sources
        #   1. Query Form
        #   2. Session (for index action only)
        def handle_somatics_filter_query
          if action_name == 'index'
            if query_hash = params[SomaticsFilter::Query::ParamName]
              store_last_query
            else
              if params[:_clear]
                clear_last_query
              else
                load_last_query_to_params
              end
            end
          end
        end
        
        def store_last_query
          session[:somatics_filter_query] ||= {}
          session[:somatics_filter_query][controller_name] = params[SomaticsFilter::Query::ParamName]
        end
        
        def clear_last_query
          session[:somatics_filter_query] ||= {}
          session[:somatics_filter_query][controller_name] = nil
        end
        
        def load_last_query_to_params
          if session[:somatics_filter_query] && session[:somatics_filter_query][controller_name]
            params[:somatics_filter_query] = session[:somatics_filter_query][controller_name]
          end
        end
      end
    end
  end
end