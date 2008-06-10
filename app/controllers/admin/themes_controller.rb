class Admin::ThemesController < ApplicationController
  
  before_filter { |c| c.send :add_stylesheet, 'themes' }
  before_filter :get_or_build_theme, :except => :index
  
  def index
    @themes = Theme.paginate :page => params[:page]
  end
  
  def new
  end
  
  def edit
    determine_current_component
  end
    
  def import_local
    theme = Theme.create :system_name => params[:system_name], :location => :local
    redirect_to edit_theme_path(theme)
  end
  
  def update
    component = @theme.components.find(params[:component_id])
    component.update_attribute :content, params[:component][:content]
    redirect_to :action => :edit, :component => component.name
  end
  
  
  protected
  
  def get_or_build_theme
    @theme = params[:id] ? Theme.find(params[:id]) : Theme.new
  end
  
  def determine_current_component
    @component = params[:component] ? @theme.components.find_by_name(params[:component]) : @theme.components.first
  end

end