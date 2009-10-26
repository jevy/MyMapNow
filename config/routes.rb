ActionController::Routing::Routes.draw do |map|
  map.resources :items

  map.root :controller => 'maps'
end
