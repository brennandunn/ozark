class Page < ActiveRecord::Base
  include Routeable, Versioned, Editable
  
  belongs_to :section
  belongs_to :layout
    
end
