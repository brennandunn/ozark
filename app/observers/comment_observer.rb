class CommentObserver < ActiveRecord::Observer
  include Dispatch::Cache
  
  def after_save(comment)
    route = comment.article.route
    cache.expire_response(route.permalink)
  end
  
end
