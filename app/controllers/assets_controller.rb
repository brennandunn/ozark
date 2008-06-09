class AssetsController < ApplicationController
  session :off

  def show
    resource = self.assistant.resource(params[:type], params[:theme], [params[:path], params[:ext]] * '.')
    if !resource
      render :text => '404'
    elsif resource.binary?
      send_data resource.read, :filename => resource.basename.to_s, :type => resource.content_type, :disposition => 'inline'
    else
      headers['Content-Type'] = resource.content_type
      render :text => resource.read
    end
  end

end
