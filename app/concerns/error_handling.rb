module ErrorHandling
  
  def self.included(klass)
    klass.rescue_from(OzarkError, :with => :rescuer)
  end
  
  
  protected
  
  # check cases
  
  def guarantee_sections
    raise Section::NoSectionsError.new if Section.count.zero?
  end
  
  # rescue action
  
  def rescuer(exception)
    render :template => "errors/#{exception.name}"
  end
    
end

class OzarkError < StandardError
  def name
    self.to_s.demodulize.gsub('Error', '').underscore
  end
end