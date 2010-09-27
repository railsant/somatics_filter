module SomaticsFilter
  module Adapters
    class MetaSearchAdapter
      class << self
        def search(query)
          condition_fragments = query.fragments.reject {|field_name, fragment| !fragment.set?}
          conditions = {}
          condition_fragments.each do |field_name, fragment|
            case fragment.operator
            when 'lt', 'lte', 'eq', 'ne', 'gte', 'gt', 'contains', 'does_not_contain'
              conditions["#{field_name}_#{fragment.operator}"] = fragment.value
            when 'yes'
              conditions["#{field_name}_eq"] = true
            when 'no'
              conditions["#{field_name}_eq"] = false
            when 'on'
              conditions["#{field_name}_eq"] = fragment.value1
            when 'before'
              conditions["#{field_name}_lt"] = fragment.value1
            when 'after'
              conditions["#{field_name}_gt"] = fragment.value1
            when 'between'
              begin
                conditions["#{field_name}_lt"] = fragment.value1
                conditions["#{field_name}_gt"] = fragment.value2
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
            ['contains', 'does_not_contain', 'eq', 'ne']
          when :text 
            ['contains', 'does_not_contain']
          when :boolean
            ['yes', 'no']
          when :list
            ['all', 'eq', 'ne']
          when :date
            ['all', 'on', 'before', 'after', 'between']
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
        
        def operators_with_second_value
          ['between']
        end
        
        def operators_without_value
          ['all', 'yes', 'no']
        end
        
        def available_filter_type
          [:integer, :float, :string, :text, :boolean, :list, :date]
        end
        
        def available_operators
          ['lt', 'lte', 'eq', 'ne', 'gte', 'gt', 'all', 'contains', 'does_not_contain', 'yes', 'no', 'on', 'before', 'after', 'between']
        end
      end
    end
  end
end