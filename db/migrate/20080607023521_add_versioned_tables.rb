class AddVersionedTables < ActiveRecord::Migration
  def self.up
    Article.create_versioned_table
    Page.create_versioned_table
    Component.create_versioned_table
  end

  def self.down
    Article.drop_versioned_table
    Page.drop_versioned_table
    Component.drop_versioned_table
  end
end
