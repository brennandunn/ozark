class Article < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  include Tags::Base, Tags::Shared
  
  Composition = ['wrapper', 'article', 'comment', 'comment_form'].freeze
  
  belongs_to :section
  has_one :theme, :through => :section
  
  has_many :comments, :dependent => :destroy, 
                      :after_add => Proc.new { |a, c| p.increment(:comments_count) }, 
                      :after_remove => Proc.new { |a, c| p.decrement(:comments_count) }
  
  
end
