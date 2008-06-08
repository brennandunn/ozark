module ErrorHandling
  
  def self.included(klass)
    klass.rescue_from(Section::NoSectionsError, :with => :rescuer)
  end
  
  
  protected
  
  def rescuer(exception)
    render :template => "errors/#{exception.name}"
  end
  
end

class OzarkError < StandardError
  def name
    self.to_s.demodulize.gsub('Error', '').underscore
  end
end