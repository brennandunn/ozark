class AddSystemNameToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :system_name, :string
  end

  def self.down
    remove_column :theme, :system_name
  end
end
