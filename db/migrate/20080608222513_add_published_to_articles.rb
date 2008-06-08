class AddPublishedToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :published_at, :datetime
    add_column :article_versions, :published_at, :datetime
  end

  def self.down
    remove_column :articles, :published_at
    remove_column :article_versions, :published_at    
  end
end
