module SomaticsFilter
  module Adapters
    class SearchlogicAdapter
      class << self
        def search(query)
          condition_fragments = query.fragments.reject {|field_name, fragment| !fragment.set?}
          conditions = {}
          condition_fragments.each do |field_name, fragment|
            case fragment.operator
            when 'lt', 'lte', 'eq', 'ne', 'gte', 'gt', 'contains'
              conditions["#{field_name}_#{fragment.operator}"] = fragment.value
            when 'does_not_contain'
              conditions["#{field_name}_not_like"] = fragment.value
            when 'true'
              conditions["#{field_name}_is"] = true
            when 'false'
              conditions["#{field_name}_is"] = false
            when 'on'
              conditions["#{field_name}_after"] = fragment.value1
              conditions["#{field_name}_before"] = fragment.value1.to_date.tomorrow.to_s
            when 'before'
              conditions["#{field_name}_#{fragment.operator}"] = fragment.value1
            when 'after'
              conditions["#{field_name}_#{fragment.operator}"] = fragment.value1.to_date.tomorrow.to_s
            when 'between'
              begin
                conditions["#{field_name}_after"] = fragment.value1
                conditions["#{field_name}_before"] = fragment.value2.to_date.tomorrow.to_s
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
            ['all', 'true', 'false']
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
          when :integer, :float, :string, :text, :boolean
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
          ['all', 'true', 'false', 'direct_apply']
        end
        
        def available_filter_type
          [:integer, :float, :string, :text, :boolean, :list, :date, :custom]
        end
      end
    end
  end
end
