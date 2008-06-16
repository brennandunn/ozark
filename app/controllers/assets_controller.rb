class AssetsController < ApplicationController
  session :off
  
  skip_before_filter :login_required
  
  def show
    resource = self.assistant.resource(params)
    if !resource
      render :text => '404'
    elsif resource.binary?
      send_data resource.read,  :filename => resource.basename.to_s, 
                                :type => resource.content_type, :disposition => 'inline'
    else
      headers['Content-Type'] = resource.content_type
      render :text => resource.read
    end
  end

end
