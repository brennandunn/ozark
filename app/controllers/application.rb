class ApplicationController < ActionController::Base
  include AuthenticatedSystem, ErrorHandling
  
  helper :all
  filter_parameter_logging :password
  
  helper_method :stylesheets, :add_stylesheet
  
  before_filter :login_required
  before_filter :set_global_host
  
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
  
  def set_global_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
end
