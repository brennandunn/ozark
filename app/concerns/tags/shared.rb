module Tags
  module Shared
    
    module InstanceMethods
      include ::Tags::Taggable      

      tag 'link' do |tag|
        %{<a href="/#{tag.locals.object.uri}">#{tag.locals.object.name}</a>}
      end
      
      # sections
      tag('sections') { |tag| tag.expand }
      tag 'sections:each' do |tag|
        ::Section.all.inject('') do |str, section|
          tag.locals.object = section
          str << tag.expand
        end
      end
      
      # articles
      tag('articles') { |tag| tag.expand }
      tag 'articles:each' do |tag|
        component = self.theme.has?('article_preview')
        tag.locals.object.articles.published.inject('') do |str, article|
          str << article.render(component)
        end
      end
      
      tag 'articles:size' do |tag|
        tag.locals.object.articles.count
      end
      
      
      tag 'stylesheet' do |tag|
        %{<link href="#{stylesheet_path(tag.attr['file'])}" media="screen" rel="stylesheet" type="text/css" />}
      end
      
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end