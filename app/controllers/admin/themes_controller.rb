class Admin::ThemesController < ApplicationController

  def index
    @themes = Theme.paginate :page => params[:page]
  end

end
