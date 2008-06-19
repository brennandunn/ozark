module Tags
  
  class TagError < StandardError ; end
  
  module Base
    
    module InstanceMethods
      include ::Tags::Taggable
      include ActionView::Helpers::DateHelper     
      include ActionView::Helpers::TagHelper 
      include ActionView::Helpers::TextHelper

      tag 'render' do |tag|
        if component = tag.attr['component']
          if found = self.respond_to?(:component) ? self.component : self.theme.has?(component)
            self.render(found)
          else
            TagError.new("Theme component '#{component}' not found")
          end
        else
          self.process!
        end
      end
            
      # conditionals
      tag 'if' do |tag|
        clean = true
        tag.attr.each do |key|
          
        end
        tag.expand if clean
      end
      
      # pluralize
      tag 'pluralize' do |tag|
        number = tag.expand.to_i
        pluralize(number, tag.attr['word'] || 'item')
      end
      
      # string columns
      [:id, :name, :content].each do |method|
        tag(method.to_s) do |tag|
          output = parse_object(self.send(method))
          case tag.attr['format']
          when /simple/i
            simple_format(output)
          else
            output
          end
        end
      end
      
      # time columns
      [:created_at, :updated_at].each do |method|
        tag(method.to_s) do |tag|
          datetime = self.send(method)
          case tag.attr['format'].downcase
          when 'time_ago'
            time_ago_in_words(datetime)
          end
        end
      end
      
      # site variables
      tag('site') { |tag| tag.expand }
      [:title, :subtitle].each do |config|
        tag("site:#{config}") do |tag|
          Configurator[:site, config]
        end
      end
      
      
      protected
      
      def stylesheet_path(name)
        "/stylesheets/#{self.theme.system_name}/#{name}.css"
      end
      
      def form_tag(uri, attributes = {}, &block)
        attributes.reverse_merge!({ :method => 'post' })
        attributes.stringify_keys!
        %{
          <form action="#{uri}"#{tag_options(attributes)}>
            #{yield}
          </form>
        }
      end

    end
    
    def self.included(receiver)
      receiver.class_eval { include ::Tags::Taggable }
      receiver.send :include, InstanceMethods
    end
  end

end