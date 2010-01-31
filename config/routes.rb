ActionController::Routing::Routes.draw do |map|
  map.resources :items, :collection => { :in_bounds => :get }
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  
  map.root :controller => 'maps'
end
