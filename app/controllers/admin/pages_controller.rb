class Admin::PagesController < ApplicationController
  
  before_filter :get_or_build_page, :except => :index
  before_filter { |c| c.send :add_stylesheet, 'pages' }
  
  def index
    @pages = Page.paginate :page => params[:page]
  end
  
  def sections
    
  end
  
  def layouts
    
  end
  
  def new
    render :action => :edit
  end
  
  
  protected
  
  def get_or_build_page
    @page = params[:id] ? Page.find(params[:id]) : Page.new
  end
  
end