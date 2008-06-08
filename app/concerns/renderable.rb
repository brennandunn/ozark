module Renderable
  
  def self.included(klass)
    klass.send :include, InstanceMethods
  end
  
  class IncompleteThemeError < StandardError ; end
  
  module InstanceMethods
    
    def render(component = nil)
      initialize_parser_and_context
      return parse_object(component) if component
      raise IncompleteThemeError.new unless self.theme.complete?
      if found_component = self.theme.has?(self.class::Composition.first)
        parse_object(found_component)
      else
        parse_object(self)
      end
    end
    
    # default catch-all
    def current
      self
    end
    
    private
    
    def initialize_parser_and_context
      unless @parser and @context
        @context = Tags::Context.new(self)
        @parser = Radius::Parser.new(@context, :tag_prefix => 'oz')
      end
    end
    
    def parse_object(object)
      @parser.parse(object.content)
    end
    
  end
  
end