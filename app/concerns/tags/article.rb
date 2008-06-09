module Tags
  module Article
    
    module InstanceMethods
      include ::Tags::Taggable

      tag 'author' do |tag|
        'Brennan Dunn'
      end
      
      tag('comments') { |tag| tag.expand }
      tag 'comments:each' do |tag|
        component = self.theme.has?('comment')
        self.comments.map do |comment|
          comment.render(component)
        end.join("\n")
      end
      
      tag 'comments:size' do |tag|
        self.comments.size
      end
      
      tag('form') { |tag| tag.expand }
      tag 'form:comment' do |tag|
        form_tag(self.uri, tag.attr) do
          tag.expand
        end
      end
      
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end