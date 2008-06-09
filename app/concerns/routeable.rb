module Routeable
  
  def self.included(klass)
    klass.send :include, InstanceMethods
    klass.class_eval do
      has_one :_route, :class_name => 'Route', :as => :associated, :dependent => :delete
      after_save :infer_route!
    end
  end
  
  def self.recognize(route_string)
    route_string = route[0...-1] if route_string.last == '/' and route_string.length > 1  # strip trailing slashes
    if route = Route.find_by_permalink(route_string)
      if route.redirect_to.blank?
        route.associated unless route.associated.respond_to?(:published_at) and route.associated.published_at.nil?
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
    
    def slug
      @slug || self.route.slug || ''
    end
    
    def slug=(str)
      @slug = str
    end
    
    def uri
      self.route.permalink if self.route
    end
    
    def dispatch_type
      :document
    end
    
    def route
      self._route || build__route
    end
    
    
    private
    
    def infer_route!
      if route.slug.blank?
        route.slug = @slug || self.name.to_slug
        route.save
      end
    end
    
  end
  
end