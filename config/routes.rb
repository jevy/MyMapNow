ActionController::Routing::Routes.draw do |map|
  map.resources :items, :member => {:approve => :put}
  
  map.root :items
end
