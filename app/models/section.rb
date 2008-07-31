class Section < ActiveRecord::Base
  include Routeable, Renderable
  include Tags::Base, Tags::Shared, Tags::Section
  
  class NoSectionsError < OzarkError ; end
  
  Composition = ['wrapper', 'section', 'article_preview']
  
  belongs_to :section
  belongs_to :theme
  
  has_many :articles, :order => 'created_at desc', :include => :_route, :dependent => :destroy
  has_many :pages, :include => :_route, :dependent => :destroy
  
  named_scope :root, :conditions => { :root => true }
  
  after_save :expire_atom
    
  class << self
    
    def determine_from_path(path)
      path =~ /feed\/(.*?)\.atom/
      find_by_name($1)
    end
    
  end  
    
  def slug
    @slug || self.route.slug.blank? ? '/' : self.route.slug || '/'
  end
  
  def slug=(str)
    @slug = str == '/' ? '' : str
  end
  
  def children(options = {})
    options.merge!({ :order => 'updated_at desc' })
    found  = articles.all(options)
    found += pages.all(options)
    found.sort! { |x, y| y.updated_at <=> x.updated_at }
    options[:limit] ? found[0, options[:limit]] : found
  end
  
  def paginate_hash
    { :page => params(:page_number) || 1, :per_page => per_page }
  end
  
  def process!
    component = theme.has?('section')
    self.render(component)
  end
  
  def total_pages
    (articles.count / per_page.to_f).ceil
  end
  
  def ok?
    return true unless params(:page_number)
    total_pages >= params(:page_number).to_i
  end
  
  
  private
    
  def infer_route_with_root!
    route.active = false unless root?
    infer_route_without_root!
  end
  alias_method_chain :infer_route!, :root
  
  def expire_atom
    cache.expire_response('feed/'+name.underscore+'.atom')
  end
  
end
