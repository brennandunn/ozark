module Versioned
  
  def self.included(klass)
    klass.send :include, InstanceMethods
    klass.class_eval do
      is_revisionary :ignore => [:live_hash]
    end
  end
  
  module InstanceMethods
    
    def current
      self.checkout(self.live_hash) || self
    end
    
  end
  
end