require 'ostruct'
require 'json'
class Theme < ActiveRecord::Base
  
  ThemesDir = [RAILS_ROOT, 'themes'] * '/'
  RequiredComponents = ['wrapper', 'section', 'article_preview', 'article', 'comment', 'comment_form'].freeze

  class NoThemesError < OzarkError ; end

  has_many :components, :order => 'name', :dependent => :destroy do
    RequiredComponents.each do |component|
      define_method(component) do
        find_by_name(component)
      end
    end
  end
  
  validates_uniqueness_of :name
  
  attr_accessor :location
  
  after_create :import
  
  class << self
    
    def available
      Dir[[ThemesDir, '*'] * '/'].map do |theme|
        meta = self.about(theme)
        arr = returning OpenStruct.new do |obj|
          obj.dir         = theme
          obj.system_name = File.basename(theme)
          obj.name        = meta['name']
        end
      end.reject { |x| self.find_by_name(x.name) }
    end
    
    def system_path(system_name)
      [ThemesDir, system_name] * '/'
    end
    
    def about(path)
      File.open([path, 'about.yml'] * '/') { |f| YAML::load(f) }
    end
    
  end
  
  def incomplete?
    not incomplete_items.empty?
  end
  
  def complete?
    not incomplete?
  end
  
  def incomplete_items
    RequiredComponents - get_components
  end
  
  def has?(component)
    components.find_by_name(component)
  end
  
  def system_path
    self.class.system_path(self.system_name)
  end
  
  def valid_layouts
    components.reject { |c| RequiredComponents.from(1).include?(c.name) }.sort_by(&:name)
  end
  
  private
  
  def get_components
    @_components ||= components.find_all_by_name(RequiredComponents).map(&:name)
  end
  
  def import
    case self.location
    when :local
      read_meta
      import_components
    else
    end
  end
  
  def read_meta
    meta = self.class.about(self.system_path)
    update_attributes :name => meta['name']
  end
  
  def import_components
    # read from json
    json = File.open([self.system_path, 'components.json'] * '/') { |f| json = f.read }
    self.components = JSON.parse(json).map do |j|
      returning Component.new do |c|
        c.attributes = j['component']
      end
    end
  end

end
