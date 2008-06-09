class Admin::SettingsController < ApplicationController

  def show
    
  end
  
  def update
    Configurator.from_hash params[:config]
    redirect_to :action => :show
  end

end
