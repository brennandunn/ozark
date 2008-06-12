module Admin::PagesHelper
  
  def theme_json
    Section.all.map { |t| t.to_json(:only => [:id, :name], 
                                    :include => { 
                                      :theme => { 
                                        :only => [:id, :name], :include => { :components => { :only => [:id, :name] } 
                                        } 
                                      }
                                    }) }.join(', ')
  end

end
