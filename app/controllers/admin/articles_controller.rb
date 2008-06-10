class Admin::ArticlesController < ApplicationController
  
  before_filter :guarantee_sections, :except => [:index, :published]
  before_filter :get_or_build_article, :except => :index

  def index
    @articles = Article.all
  end
  
  def published
    @articles = Article.published
    render :action => :index
  end
  
  def sections
    @sections = Section.all
    render :action => :index
  end
  
  def new
    render :action => :edit
  end
  
  def edit
  end
  
  def create
    @article.attributes = params[:article]
    @article.save
    redirect_to :action => :index
  end
  
  def update
    @article.attributes = params[:article]
    @article.save
    redirect_to :action => :index
  end
  
  private
  
  def get_or_build_article
    @article = params[:id] ? Article.find(params[:id]) : Article.new
  end

end
