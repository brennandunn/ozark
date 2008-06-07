module Tags
  module Section
    
    module InstanceMethods
      include ::Tags::Taggable      

      tag 'articles' do
        component = self.theme.has?('article_preview')
        self.articles.inject('') do |str, article|
          str << article.render(component)
        end
      end

    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end