class Layout < ActiveRecord::Base
  
  has_many :sections
  has_many :pages
  
end
