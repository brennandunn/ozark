class Page < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  include Tags::Base, Tags::Shared
  
  Composition = ['wrapper']
  
  belongs_to :section
  delegate :theme, :to => :section
  
  def process!
    self.render(self)
  end
  
  
  private
  
  def infer_route_with_root!
    @slug = '' if slug == '/'
    infer_route_without_root!
  end
  alias_method_chain :infer_route!, :root
    
end
