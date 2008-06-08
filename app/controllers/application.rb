class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all
  protect_from_forgery
  filter_parameter_logging :password
  
  helper_method :stylesheets, :add_stylesheet
  
  protected
  
  def stylesheets
    ['base', *(@_stylesheets || [])]
  end
  
  def add_stylesheet(name)
    @_stylesheets ||= []
    @_stylesheets << name
  end
  
end
