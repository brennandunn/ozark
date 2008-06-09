class Section < ActiveRecord::Base
  include Routeable, Renderable
  include Tags::Base, Tags::Section
  
  class NoSectionsError < OzarkError ; end
  
  Composition = ['wrapper', 'section', 'article_preview']
  
  belongs_to :section
  belongs_to :theme
  
  has_many :articles, :order => 'created_at desc', :include => :_route
  has_many :pages, :include => :_route
  
  def slug
    @slug || self.route.slug.blank? ? '/' : self.route.slug || '/'
  end
  
  def slug=(str)
    @slug = str == '/' ? '' : str
  end
  
  def children
    (articles + pages).sort { |x, y| x.route.permalink <=> y.route.permalink }
  end
  
  def process!
    component = theme.has?('section')
    self.render(component)
  end
  
end
