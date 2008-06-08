class Article < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  include Tags::Base, Tags::Shared, Tags::Article
    
  Composition = ['wrapper', 'article', 'comment', 'comment_form'].freeze
  
  belongs_to :section
  delegate :theme, :to => :section
  
  has_many :comments, :dependent => :destroy
  
  validates_presence_of :slug   # an article must have a slug attached to it
  
  def process!
    component = theme.has?('article')
    self.render(component)
  end
  
end
