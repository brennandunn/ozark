class Section < ActiveRecord::Base
  include Routeable, Renderable
  include Tags::Base, Tags::Shared, Tags::Section
  
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
  
  def children(limit = nil)
    found  = articles.find(:all, :limit => limit, :order => 'updated_at desc')
    found += pages.find(:all, :limit => limit, :order => 'updated_at desc')
    found.sort! { |x, y| y.updated_at <=> x.updated_at }
    limit ? found[0, limit] : found
  end
  
  def process!
    component = theme.has?('section')
    self.render(component)
  end
  
  
  private
    
  def infer_route_with_root!
    route.active = false unless root?
    infer_route_without_root!
  end
  alias_method_chain :infer_route!, :root
  
  
end
