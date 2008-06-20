module Dispatch
  class Base
    include Cache
    
    attr_reader :found
    
    def initialize(path, request, response)
      @path, @request, @response = path, request, response
      @found = determine_resource_from_path
    end
    
    def action
      @found.dispatch_type
    end
    
    def render
      unless serve_from_cache
        @response.body = if @found.respond_to?(:render)
                          @found.render
                        else
                          ''
                        end
        cache_response unless @found.skip_caching?
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