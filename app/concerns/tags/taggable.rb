module Tags
  module Taggable

    module ClassMethods

      def tag(name, &block)
        define_method("tag:#{name}", &block)
      end

      def tags
        Util.tags_in_array(self.instance_methods)
      end

    end

    module InstanceMethods

      def render_tag(name, tag_binding)
        send "tag:#{name}", tag_binding
      end

      def tags
        Util.tags_in_array(methods)
      end

    end

    module Util
      def self.tags_in_array(array)
        array.grep(/^tag:/).map { |name| name[4..-1] }.sort
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end