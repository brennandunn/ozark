class Admin::SectionsController < ApplicationController
  
  before_filter :guarantee_themes, :except => :index
  before_filter :get_or_build_section, :except => :index
  
  def index
    @sections = Section.paginate :page => params[:page]
  end
  
  def show
  end
  
  def new
    render :action => :edit
  end
  
  def edit
  end
  
  def create
    @section.attributes = params[:section]
    @section.save
    redirect_to :action => :index
  end
  alias :update :create
  
  def destroy
    @section.destroy
    redirect_to :action => :index
  end
  
  private
  
  def get_or_build_section
    @section = params[:id] ? Section.find(params[:id]) : Section.new
  end
  
  def guarantee_themes
    raise Theme::NoThemesError.new if Theme.count.zero?
  end

end
