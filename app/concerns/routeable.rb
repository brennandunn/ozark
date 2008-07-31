module Routeable
  
  def self.included(klass)
    klass.send :include, InstanceMethods
    klass.class_eval do
      has_one :_route, :class_name => 'Route', :as => :associated, :dependent => :delete
      after_save :infer_route!
      attr_reader :request
    end
  end
  
  def self.recognize(path_string, request = nil)
    path_string = path_string[0...-1] if path_string.last == '/' and path_string.length > 1  # strip trailing slashes
    route_string, params = extract_params!(path_string)
    if route_string.ends_with?('.atom')
      Atom.new(route_string, request)
    elsif route = Route.find_by_permalink_and_active(route_string, true)
      if route.redirect_to.blank?
        unless route.associated.respond_to?(:published_at) and route.associated.published_at.nil?
          if request
            request.parameters.merge!(params)
            route.associated.set_request(request)
            route.associated.ok? ? route.associated : nil
          else
            route.associated
          end
        end
      else
        Redirect.new(route.redirect_to)
      end
    end
  end
  
  def self.extract_params!(string)
    params = {}
    if string =~ /(.*?)page(\d+)$/
      string, params[:page_number] = $1, $2
    end
    [string, params]
  end
  
  class Redirect
    attr_reader :url
    
    def initialize(url)
      @url = url
    end
    
    def dispatch_type
      :redirect
    end
    
  end
  
  class Atom
    
    def initialize(path, request = nil)
      @section, @request = Section.determine_from_path(path), request
    end
    
    def dispatch_type
      :atom
    end
    
    def skip_caching?
      false
    end
    
    def render
      return unless @section
      ::Atom::Feed.new do |feed|
        feed.title      = "#{Configurator[:site, :title]} - #{@section.name}"
        feed.id         = UUID.new(:urn)
        feed.updated    = Time.now
        feed.entries    = @section.articles.map do |article|
          article.send(:initialize_parser_and_context)
          ::Atom::Entry.new do |e|
            e.title   = article.name 
            e.links << ::Atom::Link.new(:href => build_url(article.uri))
            e.published = article.created_at
            e.updated   = article.updated_at
            e.content   = ::Atom::Content::Html.new(article.send(:parse_object, article))
          end
        end 
      end.to_xml
    end
    
    def build_url(uri)
      @request.protocol + [@request.host, uri].join('/')
    end
    
  end
  
  module InstanceMethods
    
    def slug
      @slug || self.route.slug || ''
    end
    
    def slug=(str)
      @slug = str unless str.blank?
    end
    
    def uri(prefix = false)
      unless self.route.permalink.blank?
        str  = prefix ? '/' : ''
        str += self.route.permalink 
      else
        str  = ''
      end
      str
    end
    
    def dispatch_type
      :document
    end
    
    def route
      self._route || build__route
    end
    
    def set_request(request)
      @request = request
      self
    end
    
    def params(key)
      request.parameters[key] if request
    end
    
    # overwrite as necessary
    def ok?
      true
    end
    
    
    private
    
    def infer_route!
      if route.slug.blank? or @slug
        route.slug = @slug || name.to_slug
        route.save
      end
    end
    
  end
  
end