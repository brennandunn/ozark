class Section < ActiveRecord::Base
  include Routeable, Renderable
  include Tags::Base, Tags::Section
  
  Composition = ['wrapper', 'section', 'article_preview']
  
  belongs_to :section
  belongs_to :theme
  
  has_many :articles, :order => 'created_at desc'
  has_many :pages
  
  def process!
    component = theme.has?('section')
    self.render(component)
  end
  
end
