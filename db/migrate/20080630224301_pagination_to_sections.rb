class PaginationToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :per_page, :integer, :default => 15
  end

  def self.down
    remove_column :sections, :per_page
  end
end
