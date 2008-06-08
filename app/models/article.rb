class Article < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  include Tags::Base, Tags::Shared, Tags::Article
  
  Composition = ['wrapper', 'article', 'comment', 'comment_form'].freeze
  
  belongs_to :section
  delegate :theme, :to => :section
  
  has_many :comments, :dependent => :destroy
  
  
  def process!
    component = theme.has?('article')
    self.render(component)
  end
  
end
