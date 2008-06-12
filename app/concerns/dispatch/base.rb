module Dispatch
  class Base
    attr_reader :found
    
    def initialize(path, request, response)
      @path, @request, @response = path, request, response
      @found = determine_resource_from_path
    end
    
    def action
      @found.dispatch_type
    end
    
    def render
      @response.body = if @found.respond_to?(:render)
                        @found.current.render
                      else
                        ''
                      end
    end
    
    def error?
      @found.nil?
    end
    
    
    private
    
    def determine_resource_from_path
      Routeable::recognize(@path, @request)
    end
    
  end
end