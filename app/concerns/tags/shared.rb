module Tags
  module Shared
    
    module InstanceMethods
      include ::Tags::Taggable      

      tag 'link' do |tag|
        uri = determine_uri_handler(tag)
        content = tag.double? ? tag.expand : tag.locals.object.name
        uri.blank? ? content : %{<a href="#{uri}">#{content}</a>}
      end
      
      # sections
      tag('sections') { |tag| tag.expand }
      tag 'sections:each' do |tag|
        ::Section.root.inject('') do |str, section|
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
        tag.locals.object.articles.published.count
      end
      
      # pages
      tag('pages') { |tag| tag.expand }
      tag 'pages:each' do |tag|
        tag.locals.section.pages.map do |page|
          tag.locals.object = page
          tag.expand
        end.join("\n")
      end
      
      # cursor
      tag 'cursor' do |tag|
        tag.globals.cache[:comments]
      end
      
      # display
      tag 'code' do |tag|
        return if tag.single?
        code = tag.expand.gsub(/^\s+\n/, '')
        CodeRay.scan(code, :ruby).html( :wrap => :div )
      end
      
      [:section, :article].each do |method|
        tag("if_#{method}") do |tag|
          if self.class.to_s.downcase.intern == method
            tag.expand
          end
        end
      end
      
      tag 'stylesheet' do |tag|
        %{<link href="#{stylesheet_path(tag.attr['file'])}" media="screen" rel="stylesheet" type="text/css" />}
      end
      
      
      private
      
      def determine_uri_handler(tag)
        if tag.attr['on']
          response = tag.locals.object.send(tag.attr['on'].intern)
          return  case response
                  when '' : ''
                  when Format::EMAIL : "mailto:#{response}"
                  else response
                  end
        end
        '/' + tag.locals.object.uri
      end
      
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end