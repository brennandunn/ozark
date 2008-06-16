require 'uri'
class Comment < ActiveRecord::Base
  include Renderable
  include Tags::Base, Tags::Shared
  
  belongs_to :article
    
  validates_presence_of :name, :email, :content, :ip_address
  validates_format_of :email, :with => Format::EMAIL
  
  before_validation :clean_email
  before_validation :clean_website
  
  
  private
  
  def clean_email
    email.strip!
  end
  
  def clean_website
    website.strip!
    website = "http://#{website}" unless website.blank? || website[0..0] == '/' || URI::parse(website).scheme
  end
  
end
