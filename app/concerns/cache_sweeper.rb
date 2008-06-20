module CacheSweeper
  
  module Component
    
    def after_update
      theme.sections.each do |section|
        section.articles.find(:all, :include => :_route).each do |article|
          Dispatch::ResponseCache.instance.expire_response(article.uri)
        end
      end
    end
    
  end
  
end