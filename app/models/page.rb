class Page < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  include Tags::Base, Tags::Shared
  
  Composition = ['wrapper']
  
  belongs_to :section
  delegate :theme, :to => :section
  
  def process!
    self.render(self)
  end
    
end
