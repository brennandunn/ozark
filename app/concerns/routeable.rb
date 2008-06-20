module Routeable
  
  def self.included(klass)
    klass.send :include, InstanceMethods
    klass.class_eval do
      has_one :_route, :class_name => 'Route', :as => :associated, :dependent => :delete
      after_save :infer_route!
      attr_reader :request
    end
  end
  
  def self.recognize(route_string, request = nil)
    route_string = route[0...-1] if route_string.last == '/' and route_string.length > 1  # strip trailing slashes
    if route = Route.find_by_permalink_and_active(route_string, true)
      if route.redirect_to.blank?
        unless route.associated.respond_to?(:published_at) and route.associated.published_at.nil?
          if request
            route.associated.set_request(request)
          else
            route.associated
          end
        end
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
      @slug = str unless str.blank?
    end
    
    def uri(prefix = false)
      unless self.route.permalink.blank?
        str  = prefix ? '/' : ''
        str += self.route.permalink 
      else
        str  = ''
      end
      str
    end
    
    def dispatch_type
      :document
    end
    
    def route
      self._route || build__route
    end
    
    def set_request(request)
      @request = request
      self
    end
    
    
    private
    
    def infer_route!
      if route.slug.blank? or @slug
        route.slug = @slug || name.to_slug
        route.save
      end
    end
    
  end
  
end