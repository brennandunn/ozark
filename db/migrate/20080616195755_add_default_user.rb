class AddDefaultUser < ActiveRecord::Migration
  def self.up
    User.create :login => 'admin', :password => 'ozarkadmin', :password_confirmation => 'ozarkadmin', 
                :name => 'Ozark Administrator', :email => 'admin@ozark.com'
  end

  def self.down
  end
end
