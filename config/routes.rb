ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.with_options :name_prefix => nil do |a|
      a.resource        :session
      a.resources       :articles, :collection => { :published => :get }
      a.resources       :pages
      a.resources       :sections
      a.with_options :path_prefix => 'admin/settings' do |s|
        s.resources     :themes
      end
      a.resource        :settings
      a.with_options :controller => 'dashboard' do |d|
        d.sitemap       'sitemap',      :action => 'sitemap'
        d.dashboard     '',             :action => 'index'
      end
    end 
  end
  
  map.connect ':type/:theme/:path.:ext', :controller => 'assets', :action => 'show', :type => /stylesheets|images|javascripts/      
  map.connect '*path',  :controller => 'render',  :action => 'dispatch'
  
end
