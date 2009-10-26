ActionController::Routing::Routes.draw do |map|
  map.resources :items, :collection => { :in_bounds => :get }

  map.root :controller => 'maps'
end
