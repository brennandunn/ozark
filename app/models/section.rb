class Section < ActiveRecord::Base
  include Routeable
  
  belongs_to :section
  belongs_to :layout
  
  has_many :articles, :order => 'created_at desc'
  has_many :pages
  
end
