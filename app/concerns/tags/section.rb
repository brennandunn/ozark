module Tags
  module Section
    
    module InstanceMethods
      include ::Tags::Taggable      

    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
    
  end
end