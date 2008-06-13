class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.references    :parent
      t.references    :associated, :polymorphic => true
      t.string        :slug
      t.text          :permalink
      t.text          :redirect_to
      t.boolean       :active, :default => true
    end
  end

  def self.down
    drop_table :routes
  end
end
