class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.references        :theme
      t.string            :name
      t.boolean           :root,  :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
