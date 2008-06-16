require 'uri'
class Comment < ActiveRecord::Base
  include Renderable
  include Tags::Base, Tags::Shared
  
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
