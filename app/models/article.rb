class Article < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  include Tags::Base, Tags::Shared, Tags::Article
    
  Composition = ['wrapper', 'article', 'comment', 'comment_form'].freeze
  
  belongs_to :section
  delegate :theme, :to => :section
  
  has_many :comments, :dependent => :destroy
  
  named_scope :all, :order => 'updated_at desc', :include => :_route
  named_scope :published, :conditions => ['published_at is not null'], :order => 'updated_at desc', :include => :_route
    
  validates_presence_of :name
  validates_uniqueness_of :name  
    
  def published?
    not published_at.nil?
  end
  
  def published
    published_at.nil? ? '0' : '1'
  end
  
  def published=(str)
    case str
    when '0'
      self.published_at = nil
    when '1'
      self.published_at = Time.now
    end
  end
  
  def process!
    if request.post?
      comments.create request.parameters[:comment]
    end
    component = theme.has?('article')
    self.render(component)
  end
  
end
