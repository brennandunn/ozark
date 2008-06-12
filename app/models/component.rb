class Component < ActiveRecord::Base
  include Versioned, Renderable
  
  belongs_to :theme
  
  has_many :sections
  has_many :pages
  
  def required?
    Theme::RequiredComponents.include?(name)
  end
  
end
