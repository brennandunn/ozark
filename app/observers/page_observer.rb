class PageObserver < ActiveRecord::Observer
  include Dispatch::Cache
  
  def after_save(page)
    cache.expire_response(page.route.permalink)
  end

end
