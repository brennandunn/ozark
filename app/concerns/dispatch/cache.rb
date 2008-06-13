module Dispatch
  module Cache
    
    def self.included(klass)
      klass.send :include, InstanceMethods
    end
    
    module InstanceMethods
      
      def cache_response
        cache.cache_response(@path, @response) if cacheable_request
      end
      
      def serve_from_cache
        if cache.response_cached?(@path) and cacheable_request
          cache.update_response(@path, @response, @request)
          return true
        end
      end
      
      
      protected
      
      def cache
        @_cache ||= ResponseCache.instance
      end
      
      def cacheable_request
        @request.get? || @request.head?
      end
      
    end
    
  end
end