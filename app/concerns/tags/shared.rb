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
          str << tag.render('link')
        end
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