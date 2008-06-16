class Admin::ThemesController < ApplicationController
  
  before_filter { |c| c.send :add_stylesheet, 'themes' }
  before_filter :get_or_build_theme, :except => :index
  before_filter :determine_current_component, :only => [:edit, :destroy_component]
  
  def index
    @themes = Theme.paginate :page => params[:page]
  end
  
  def new
  end
  
  def edit
  end
  
  def create
    @theme.attributes = params[:theme]
    @theme.save!
    Theme::RequiredComponents.each do |component|
      @theme.components.create :name => component
    end
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
  end
  
  def new_component
    component = @theme.components.create :name => params[:new_component_name].downcase
    redirect_to edit_theme_path(@theme, { :component => component.name })
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
  
  def destroy_component
    @component.destroy
    redirect_to :action => :edit
  end
  
  
  protected
  
  def get_or_build_theme
    @theme = params[:id] ? Theme.find(params[:id]) : Theme.new
  end
  
  def determine_current_component
    @component = params[:component] ? @theme.components.find_by_name(params[:component]) : @theme.components.first
  end

end