class AssistantProxy
  
  def initialize(reference)
    @reference = reference
  end
  
  def resource(type, theme, query_path)
    @type, @theme, @query_path = type, theme, query_path
    if resource = file_exists_in_theme
      resource
    else
      nil
    end
  end
  
  
  private
  
  def file_exists_in_theme
    resource = Pathname.new([RAILS_ROOT, 'themes', @theme, @type, @query_path] * '/')
    resource.file? ? resource : nil
  end
  
end