module Renderable
  
  def self.included(klass)
    klass.send :include, Dispatch::Cache
    klass.send :include, InstanceMethods
    klass.class_eval do
      attr_accessor :skip_caching
    end
  end
  
  class IncompleteThemeError < StandardError ; end
  
  module InstanceMethods
    
    def render(component = nil)
      initialize_parser_and_context
      return parse_object(component) if component
      raise IncompleteThemeError.new if self.theme.incomplete?
      if found_component = determine_layout
        parse_object(found_component)
      else
        parse_object(self)
      end
    end
    
    def skip_caching?
      self.skip_caching
    end
    
    # default catch-all
    def current
      self
    end
    
    # ensures this callback is executed last
    def after_save
      cache.expire_response(route.permalink) if self.respond_to?(:route) && !self.route.permalink.blank?
    end
    
    
    private
    
    def initialize_parser_and_context
      unless @parser and @context
        @context = Tags::Context.new(self)
        @parser = Radius::Parser.new(@context, :tag_prefix => 'oz')
      end
    end
    
    def parse_object(object)
      @parser.parse(object.respond_to?(:content) ? object.content : object)
    end
    
    def determine_layout
      (self.respond_to?(:component_id) and self.component_id) ? Component.find(self.component_id) : self.theme.has?(self.class::Composition.first)
    end
    
  end
  
end