module Tags
  
  class TagError < StandardError ; end
  
  module Base
    
    module InstanceMethods
      include ::Tags::Taggable
      include ActionView::Helpers::DateHelper      

      tag 'render' do |tag|
        if component = tag.attr['component']
          if found = self.respond_to?(:component) ? self.component : self.theme.has?(component)
            found.content
          else
            TagError.new("Theme component '#{component}' not found")
          end
        else
          self.process!
        end
      end
      
      [:name, :content].each do |method|
        tag(method.to_s) do |tag|
          self.send(method)
        end
      end
      
      [:created_at, :updated_at].each do |method|
        tag(method.to_s) do |tag|
          datetime = self.send(method)
          case tag.attr['format'].downcase
          when 'time_ago'
            time_ago_in_words(datetime)
          end
        end
      end

    end
    
    def self.included(receiver)
      receiver.class_eval { include ::Tags::Taggable }
      receiver.send :include, InstanceMethods
    end
  end

end