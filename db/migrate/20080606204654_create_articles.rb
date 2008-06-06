class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.references        :section
      t.string            :name,              :limit => 128
      t.text              :description
      t.text              :content      
      t.references        :author
      t.integer           :comments_count,    :default => 0
      t.string            :live_hash
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
