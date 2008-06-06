class Section < ActiveRecord::Base
  
  belongs_to :layout
  
  has_many :articles
  has_many :pages
  
end
