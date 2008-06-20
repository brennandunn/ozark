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
  
  after_save :expire_atom
  
  attr_accessor :new_comment
    
  def previous
    section.articles.find :first, :conditions => ['created_at > ?', created_at]
  end  
  
  def next
    section.articles.find :first, :conditions => ['created_at < ?', created_at]
  end
    
  def published?
    not published_at.nil?
  end
  
  def published
    published_at.nil? ? '0' : '1'
  end
  
  def published=(str)
    self.published_at = str.to_i.zero? ? nil : Time.now
  end
  
  def process!
    if request.post?
      self.new_comment = Comment.new(request.parameters[:comment].merge( {  :ip_address => request.remote_ip, 
                                                                            :user_agent => request.env['HTTP_USER_AGENT'] } ))
      comments << new_comment if new_comment.valid? and !new_comment.spam?
    end
    component = theme.has?('article')
    self.render(component)
  end
  
  
  private
  
  def expire_atom
    cache.expire_response('feed/'+self.section.name.underscore+'.atom')
  end
  
end
