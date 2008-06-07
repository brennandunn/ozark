class Page < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  
  belongs_to :section
  belongs_to :layout
    
end
