class Admin::SectionsController < ApplicationController
  
  before_filter :get_or_build_section, :except => :index
  
  def index
    @sections = Section.paginate :page => params[:page]
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
  
  private
  
  def get_or_build_section
    @section = params[:id] ? Section.find(params[:id]) : Section.new
  end

end
