class Theme < ActiveRecord::Base
  
  RequiredComponents = ['wrapper', 'header', 'footer', 'section', 'article_preview', 'article', 'comment', 'comment_form'].freeze

  has_many :components, :class_name => 'Layout' do
    RequiredComponents.each do |component|
      define_method(component) do
        find_by_name(component)
      end
    end
  end
  
  def incomplete?
    get_components.include?(nil)
  end
  
  def complete?
    not incomplete?
  end
  
  def incomplete_items
    RequiredComponents - get_components.compact.map(&:name)
  end
  
  def has?(component)
    components.find_by_name(component)
  end
  
  
  private
  
  def get_components
    @_components ||= RequiredComponents.map do |component|
                      components.send(component)
                     end
  end

end
