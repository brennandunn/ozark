class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.references        :section
      t.references        :layout
      t.string            :name
      t.text              :content
      t.references        :last_updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
