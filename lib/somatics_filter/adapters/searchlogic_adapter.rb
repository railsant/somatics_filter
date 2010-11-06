module SomaticsFilter
  module Adapters
    class SearchlogicAdapter
      class << self
        def search(query)
          condition_fragments = query.fragments.reject {|field_name, fragment| !fragment.set?}
          conditions = {}
          condition_fragments.each do |field_name, fragment|
            case fragment.operator
            when 'lt', 'lte', 'eq', 'ne', 'gte', 'gt', 'like', 'not_like', 'equals', 'does_not_equal'
              conditions["#{field_name}_#{fragment.operator}"] = fragment.value
            when 'equals_true'
              conditions["#{field_name}_is"] = true
            when 'equals_false'
              conditions["#{field_name}_is"] = false
            when 'on_some_date'
              conditions["#{field_name}_is"] = fragment.value1
            when 'before', 'after'
              conditions["#{field_name}_#{fragment.operator}"] = fragment.value1
            when 'between'
              begin
                conditions["#{field_name}_after"] = fragment.value1
                conditions["#{field_name}_before"] = fragment.value2
              rescue
              end
            when 'direct_apply'
              conditions["#{field_name}"] = true
            else
            end
          end
          query.model.search(conditions)
        end
        
        # Return Array of available operators for a given field type supplied by searchlogic
        def available_operators_of_filter_type(type)
          case type
          when :integer
            ['all', 'lt', 'lte', 'eq', 'ne', 'gte', 'gt']
          when :float
            ['all', 'lt', 'lte', 'eq', 'ne', 'gte', 'gt']
          when :string
            ['like', 'not_like', 'equals', 'does_not_equal']
          when :text 
            ['like', 'not_like']
          when :boolean
            ['equals_true', 'equals_false']
          when :list
            ['all', 'eq', 'ne']
          when :date
            ['all', 'on_some_date', 'before', 'after', 'between']
          when :custom
            ['direct_apply']
          end
        end
        
        def input_field_of_filter(filter, form)
          case filter.type
          when :integer, :string, :text, :boolean
            form.send(:text_field, :value)
          when :list
            form.send(:select, :value, filter.options[:values])
          when :date
            "#{form.send(:calendar_date_select, :value1, :style => 'width:120px;')}<span id=\"div_values2_#{filter.field_name}\"> and #{form.send(:calendar_date_select, :value2, :style => 'width:120px;')}</span>"
          end
        end
        
        def callback_for(filter, model)
        end
        
        def operators_with_second_value
          ['between']
        end
        
        def operators_without_value
          ['all', 'equals_true', 'equals_false']
        end
        
        def available_filter_type
          [:integer, :float, :string, :text, :boolean, :list, :date, :custom]
        end
      end
    end
  end
end
