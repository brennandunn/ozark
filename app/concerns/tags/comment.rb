module Tags
  module Comment
    
    module InstanceMethods
      include ::Tags::Taggable      

      tag 'gravatar' do |tag|
        send(:gravatar_url)
      end

    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end