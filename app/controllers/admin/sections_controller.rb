class Admin::SectionsController < ApplicationController

  def index
    @sections = Section.paginate :page => params[:page]
  end

end
