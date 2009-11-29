ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :user_sessions
  
  map.resources :items, :collection => { :in_bounds => :get }
  map.facebook_login '/maps/facebook_login', :controller=>'maps', :action=>'facebook_login'
  map.root :controller => 'maps'
end
