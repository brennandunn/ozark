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
  
  attr_accessor :new_comment
    
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
      self.new_comment = Comment.create(request.parameters[:comment].merge( { :ip_address => request.remote_ip } ))
      comments << new_comment if new_comment.valid?
    end
    component = theme.has?('article')
    self.render(component)
  end
  
end
