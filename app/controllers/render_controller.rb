class RenderController < ApplicationController
  session :off
  layout nil
  
  skip_before_filter :login_required
    
  def dispatch
    @dispatch = Dispatch::Base.new(path, request, response)
    @dispatch.error? ? show_404 : send("handle_#{@dispatch.action}")
  end
  
  def handle_redirect
    redirect_to @dispatch.found.url
  end
  
  def handle_document
    @dispatch.render ; finish!
  end
  
  def handle_atom
    @dispatch.render ; finish!
  end
  
  private
  
  def path
    @path ||= [*params[:path]].join('/')
  end
  
  def finish!
    @performed_render = true
  end
  
  def show_404
    render :text => "Can't find resource"
  end
  
end
