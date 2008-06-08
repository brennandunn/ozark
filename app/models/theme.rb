class Theme < ActiveRecord::Base
  
  RequiredComponents = ['wrapper', 'section', 'article_preview', 'article', 'comment', 'comment_form'].freeze

  has_many :components do
    RequiredComponents.each do |component|
      define_method(component) do
        find_by_name(component)
      end
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
  
  
  private
  
  def get_components
    @_components ||= components.find_all_by_name(RequiredComponents).map(&:name)
  end

end
