class ArticleObserver < ActiveRecord::Observer
  include Dispatch::Cache
  
  def after_save(article)
    cache.expire_response(article.route.permalink)
  end
  alias :before_destroy :after_save

end
