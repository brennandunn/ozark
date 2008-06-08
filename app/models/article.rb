class Article < ActiveRecord::Base
  include Routeable, Versioned, Renderable
  include Tags::Base, Tags::Shared, Tags::Article
    
  Composition = ['wrapper', 'article', 'comment', 'comment_form'].freeze
  
  belongs_to :section
  delegate :theme, :to => :section
  
  has_many :comments, :dependent => :destroy
  
  named_scope :all, :order => 'created_at'
  named_scope :published, :conditions => ['published_at is not null'], :order => 'created_at'
  
  validates_presence_of :slug   # an article must have a slug attached to it
  
  def published?
    not published_at.nil?
  end
  
  def process!
    component = theme.has?('article')
    self.render(component)
  end
  
end
