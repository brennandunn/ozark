class Admin::PagesController < ApplicationController
  
  before_filter :guarantee_sections, :except => [:index, :published]
  before_filter :get_or_build_page, :except => :index
  before_filter { |c| c.send :add_stylesheet, 'articles' }
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
  
  def create
    @page.attributes = params[:page]
    @page.save
    redirect_to :action => :index
  end
  alias :update :create
  
  
  protected
  
  def get_or_build_page
    @page = params[:id] ? Page.find(params[:id]) : Page.new
  end
  
end