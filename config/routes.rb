ActionController::Routing::Routes.draw do |map|
  map.resources :items, :collection => { :in_bounds => :get }
  map.facebook_login '/maps/facebook_login', :controller=>'maps', :action=>'facebook_login'
  map.root :controller => 'maps'
end
