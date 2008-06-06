class Route < ActiveRecord::Base

  belongs_to :associated, :polymorphic => true
  
  before_save :compile_permalink
  
  def permalink=(permalink_str)
    write_attribute :permalink, permalink_str.gsub('//', '/')
  end
  
  
  private
  
  def compile_permalink
    
  end

end
