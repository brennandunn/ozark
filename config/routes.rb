ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.with_options :name_prefix => nil do |a|
      a.resource      :session
    end 
  end

  map.connect   '*path',  :controller => 'render',  :action => 'dispatch'
  
end
