class CreateSomaticsFilterQueries < ActiveRecord::Migration
  def self.up
    create_table :somatics_filter_queries do |t|
      t.string   :name
      t.string   :query_class_name
      t.text     :search_params
      t.text     :column_params
      t.string   :whodunnit
      
      t.timestamps
    end
    add_index :somatics_filter_queries, :query_class_name
  end

  def self.down
    remove_index :somatics_filter_queries, :query_class_name
    drop_table :somatics_filter_queries
  end
end