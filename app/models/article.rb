class Article < ActiveRecord::Base
  include Routeable, Versioned, Editable
  
  belongs_to :section
  belongs_to :layout, :through => :section
  
  has_many :comments, :dependent => :destroy, 
                      :after_add => Proc.new { |a, c| p.increment(:comments_count) }, 
                      :after_remove => Proc.new { |a, c| p.decrement(:comments_count) }
  
  
end
