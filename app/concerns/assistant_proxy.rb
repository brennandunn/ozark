class AssistantProxy
  
  def initialize(reference)
    @reference = reference
  end
  
  def resource(params)
    @type, @theme, @query_path = params[:type], params[:theme], [params[:path], params[:ext]] * '.'
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