Given 'a news story in $location titled "$title"' do |location, title|
  l = LOCATIONS[location]
  Geocode.geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude
end

When 'I click on the news story titled "$title" on the map' do |title|
  selenium.js_eval "var marker = window.$('aside li h2:contains(#{title}):first').parent().data('marker');
    window.google.maps.event.trigger(marker, 'click');"
end

When 'I click on the news story titled "$title" in the list' do |title|
  selenium.js_eval "window.$('aside li h2:contains(#{title})').click()"
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

Then 'I see the news story titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("aside h2:contains(#{title})")
  assert_have_selector("#map *[title='#{title}']")
end

Then 'I see the news story titled "$title" once' do |title|
  pending
  Then %Q{I see the news story titled "#{title}"}
  assert_have_selector("aside h2:contains(#{title}):lt(1)")
  assert_have_selector("#map *[title='#{title}']:lt(1)")
  
  assert_have_no_selector("aside h2:contains(#{title}):gt(0)")
  assert_have_no_selector("#map *[title='#{title}']:gt(0)")
end


Then 'I do not see the news story titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_no_selector("aside h2:contains(#{title})")
  assert_have_no_selector("#map *[title='#{title}']")
end

Then 'I see the news story titled "$title" highlighted on the map' do |title|
  assert_have_selector("#map h2:contains(#{title})")
end

Then 'I see the news story titled "$title" highlighted in the list' do |title|
  assert_have_selector("aside li.active h2:contains(#{title})")
end

Then 'I see the news story titled "$title" is not highlighted' do |title|
  assert_have_no_selector("aside li.active h2:contains(#{title})")
  assert_have_no_selector("#map h2:contains(#{title})")
end