module Tags
  module Article
    
    module InstanceMethods
      include ::Tags::Taggable
      include ActionView::Helpers::FormTagHelper
      include WhiteListHelper

      tag 'author' do |tag|
        'Brennan Dunn'
      end
      
      # next and previous
      tag 'next_and_previous' do |tag|
        previous_article   =  self.previous ? 
                              %{<span class="previous"><a href="#{self.previous.uri}">&larr; #{self.previous.name}</a></span>} :
                              nil
        
        next_article       =  self.next ? 
                              %{<span class="previous"><a href="#{self.next.uri}">&rarr; #{self.next.name}</a></span>} :
                              nil    
                              
        section            =  tag.attr['section'] ? %{<span class="section"><a href="#{self.section.uri(true)}">#{self.section.name}</a></span>} : nil                                      
                    
        %{<div class="next_and_previous">} + [previous_article, section, next_article].compact.join('') + %{</div>}
      end
      
      # comments
      tag('comments') { |tag| tag.expand }
      tag 'comments:each' do |tag|
        begin
          component = self.theme.has?('comment')
          tag.locals.object.comments.map_with_index do |comment, idx|
            tag.globals.cache[:comments] = idx + 1
            white_list(comment.render(component))
          end.join("\n")
        ensure
          tag.globals.cache.delete(:comments)
        end
      end
      
      tag 'comments:size' do |tag|
        tag.locals.object.comments.count
      end
      
      tag('form') { |tag| tag.expand }
      tag 'form:comment' do |tag|
        form_tag(self.uri, tag.attr) do
          tag.expand
        end
      end
      
      # inputs
      tag('input') { |tag| tag.expand }
      [:name, :email, :website].each do |method|
        tag("input:#{method}") do |tag|
          text_field_tag "comment[#{method}]", nil, tag.attr
        end
      end
      
      tag 'input:content' do |tag|
        text_area_tag 'comment[content]', nil, tag.attr
      end
      
      tag 'input:error' do |tag|
        return unless self.new_comment or tag.attr['on'].blank?
        self.new_comment.errors.on(tag.attr['on'].intern)
      end
      
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end