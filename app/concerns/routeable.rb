module Routeable
  
  def self.included(klass)
    klass.send :include, InstanceMethods
    klass.class_eval do
      has_one :route, :dependent => :delete_all
    end
  end
  
  def self.recognize(route_string)
    route_string = route[0...-1] if route_string.last == '/' and route_string.length > 1  # strip trailing slashes
    if route = Route.find_by_permalink(route_string)
      if route.redirect_to.blank?
        route.associated
      else
        Redirect.new(route.redirect_to)
      end
    end
  end
  
  class Redirect
    attr_reader :url
    
    def initialize(url)
      @url = url
    end
    
    def dispatch_type
      :redirect
    end
    
  end
  
  module InstanceMethods
    
    def uri
      self.route.permalink if self.route
    end
    
    def dispatch_type
      :document
    end
    
    def route=(route_str)
      route ? route.update_attributes(:slug => route_str) : create_route(:slug => route_str)
    end
    
  end
  
end