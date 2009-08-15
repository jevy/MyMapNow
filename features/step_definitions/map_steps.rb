Given "I am viewing the map" do
  visit root_path
end  

When "I view the map" do
  Given "I am viewing the map"
end

When 'I zoom out' do
  selenium.js_eval "window.Map.map.set_zoom(window.Map.map.get_zoom()-1);"
end

When 'I zoom in' do
  selenium.js_eval "window.Map.map.set_zoom(window.Map.map.get_zoom()+1);"
end

When 'I center the map on $location' do |location|
  l = LOCATIONS[location]
  selenium.js_eval "window.Map.map.set_center(new window.google.maps.LatLng(#{l.latitude}, #{l.longitude}));"
end

