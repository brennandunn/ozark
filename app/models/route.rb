class Route < ActiveRecord::Base

  belongs_to :associated, :polymorphic => true
  
  before_save :compile_permalink
  
  validates_uniqueness_of :permalink, :scope => :active
  validates_non_format_of :permalink, :with => /^admin/i
  
  attr_accessor :ignore_compile
  
  named_scope :attached, :conditions => ['associated_id is not null']
  named_scope :redirects, :conditions => ['redirect_to is not null']
  
  class << self
    
    def redirect!(permalink, uri)
      self.create :permalink => permalink, :redirect_to => uri, :ignore_compile => true
    end
    
    def sitemap
      attached.find(:all, :order => 'permalink asc', :include => :associated).reject do |r|
        (r.associated.respond_to?(:root) && !r.associated.root) ? true : false
      end
    end
    
  end
  
  def display_slug
    slug.blank? ? '/' : slug
  end
  
  def display_permalink
    '/' + permalink
  end
  
  private
  
  def compile_permalink
    return if self.ignore_compile
    self.permalink = if associated && associated.respond_to?(:section) && associated.section
                      [associated.section.uri, slug].reject(&:blank?) * '/'
                     else
                      slug
                     end
  end

end
