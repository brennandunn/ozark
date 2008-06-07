class Route < ActiveRecord::Base

  belongs_to :associated, :polymorphic => true
  
  before_save :compile_permalink
  
  attr_accessor :ignore_compile
  
  class << self
    
    def redirect!(permalink, uri)
      self.create :permalink => permalink, :redirect_to => uri, :ignore_compile => true
    end
    
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
