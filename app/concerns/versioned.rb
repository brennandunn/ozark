module Versioned
  
  def self.included(klass)
    klass.send :include, InstanceMethods
    klass.class_eval do
      
      acts_as_versioned :if_changed => [:name, :content], :limit => 5 do
        
      end
      
    end
  end
  
  module InstanceMethods
    
    def current
      self
    end
    
  end
  
end