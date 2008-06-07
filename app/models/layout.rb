class Layout < ActiveRecord::Base
  include Versioned, Editable
  
  has_many :sections
  has_many :pages
  
end
