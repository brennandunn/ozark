module Tags
  module Article
    
    module InstanceMethods
      include ::Tags::Taggable      

      tag 'author' do |tag|
        'Brennan Dunn'
      end
      
      tag 'comments' do |tag|
        component = self.theme.has?('comment')
        self.comments.map do |comment|
          comment.render(component)
        end.join("\n")
      end
      
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end