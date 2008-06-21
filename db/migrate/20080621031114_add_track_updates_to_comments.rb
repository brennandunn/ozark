class AddTrackUpdatesToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :track_updates, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :track_updates
  end
end
