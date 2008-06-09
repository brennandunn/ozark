class ApplicationController < ActionController::Base
  include AuthenticatedSystem, ErrorHandling
  
  helper :all
  protect_from_forgery
  filter_parameter_logging :password
  
  helper_method :stylesheets, :add_stylesheet
  
  def assistant
    @_assistant ||= AssistantProxy.new(self)
  end
  
  
  protected
  
  def guarantee_sections
    raise Section::NoSectionsError.new if Section.count.zero?
  end
  
  def stylesheets
    ['base', *(@_stylesheets || [])]
  end
  
  def add_stylesheet(name)
    @_stylesheets ||= []
    @_stylesheets << name
  end
  
end
