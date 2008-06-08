module Tags
  module Shared
    
    module InstanceMethods
      include ::Tags::Taggable      

      tag 'link' do |tag|
        %{<a href="/#{self.uri}">#{self.name}</a>}
      end
      
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end