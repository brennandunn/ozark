class ApplicationController < ActionController::Base
  include AuthenticatedSystem, ErrorHandling
  
  helper :all
  filter_parameter_logging :password
  
  helper_method :stylesheets, :add_stylesheet
  
  before_filter :login_required
  
  def assistant
    @_assistant ||= AssistantProxy.new(self)
  end
  
  
  protected
  
  def stylesheets
    ['base', *(@_stylesheets || [])]
  end
  
  def add_stylesheet(name)
    @_stylesheets ||= []
    @_stylesheets << name
  end
  
end
