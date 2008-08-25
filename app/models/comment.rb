require 'uri'
class Comment < ActiveRecord::Base
  include Renderable
  include Tags::Base, Tags::Shared, Tags::Comment
  
  belongs_to :article
    
  has_rakismet  :author => :name,
                :author_email => :email, 
                :author_url => :website, 
                :user_ip => :ip_address
    
  validates_presence_of :name, :email, :content, :ip_address
  validates_format_of :email, :with => Format::EMAIL
  
  before_validation :clean_email
  before_validation :clean_website
  
  attr_accessor :user_agent
  
  def spam_with_key_defined?
    unless Rakismet::KEY.blank? || Rakismet::URL.blank?
      spam_without_key_defined?
    else
      true
    end
  end
  alias_method_chain :spam?, :key_defined
  
  def gravatar_url
    "http://www.gravatar.com/avatar/#{encrypted_email}?s=60"
  end
  
  def observers
    article.comments.find_all_by_track_updates(true).map(&:email).uniq
  end
  
  def encrypted_email
    Digest::MD5.hexdigest(email)
  end
  
  
  private
  
  def clean_email
    email.strip!
  end
  
  def clean_website
    website.strip!
    website = "http://#{website}" unless website.blank? || website[0..0] == '/' || URI::parse(website).scheme
  end
  
  def comment_type
    'comment'
  end
  
end