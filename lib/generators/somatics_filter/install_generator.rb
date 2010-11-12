require 'rails/generators/migration'

module SomaticsFilter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../../templates', __FILE__)    
      desc "Generate migration for somatics filter."

      def generate_query_migration
        migration_template 'migration.rb', "db/migrate/create_somatics_filter_queries.rb"
      end

      private

      def self.next_migration_number(dirname)
        if ::ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end