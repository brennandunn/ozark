class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references        :article
      t.references        :user       # if comment is from admin
      t.string            :name
      t.string            :email
      t.string            :website
      t.text              :content
      t.string            :ip_address
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
