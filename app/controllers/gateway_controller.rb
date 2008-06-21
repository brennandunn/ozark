class GatewayController < ApplicationController

  def stop_watching
    @article = Article.find(params[:article_id])
    @article.cancel_watching_for(params[:encrypted_email])
  end

end
