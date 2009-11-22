ActionController::Routing::Routes.draw do |map|
  map.resource :user_sessions

  map.resource :account, :controller => "users"
  map.resources :users


  map.resources :items, :collection => { :in_bounds => :get, :in_bounds_for_timeline => :get }
  map.facebook_login '/maps/facebook_login', :controller=>'maps', :action=>'facebook_login'
  map.root :controller => 'maps'
end
