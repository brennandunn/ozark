module Renderable
  
  def self.included(klass)
    klass.send :include, InstanceMethods
  end
  
  module InstanceMethods
    
    def render(component = nil)
      initialize_parser_and_context
      return parse_object(component) if component
      if found_component = self.theme.has?(self.class::Composition.first)
        parse_object(found_component)
      else
        parse_object(self)
      end
    end
    
    
    private
    
    def initialize_parser_and_context
      unless @parser and @context
        @context = Tags::Context.new(self)
        @parser = Radius::Parser.new(@context, :tag_prefix => 'o')
      end
    end
    
    def parse_object(object)
      @parser.parse(object.content)
    end
    
  end
  
end