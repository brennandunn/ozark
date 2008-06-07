module Tags
  
  class TagError < StandardError ; end
  
  module Base
    
    module InstanceMethods
      include ::Tags::Taggable      

      tag 'render' do |tag|
        if component = tag.attr['component']
          if found = self.theme.has?(component)
            found.content
          else
            TagError.new("Theme component '#{component}' not found")
          end
        else
          self.process!
        end
      end
      
      [:name, :created_at, :updated_at].each do |method|
        tag(method.to_s) do |tag|
          self.send(method)
        end
      end

    end
    
    def self.included(receiver)
      receiver.class_eval { include ::Tags::Taggable }
      receiver.send :include, InstanceMethods
    end
  end

end