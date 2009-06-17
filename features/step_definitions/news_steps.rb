Given 'a news story in $location titled "$title"' do |location, title|
  l = LOCATIONS[location]
  Geocode.geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude
end

When 'I click on the news story titled "$title" on the map' do |title|
  selenium.js_eval "var id = window.$('aside li h2:contains(#{title}):first').parent().attr('data-item-id');
    window.google.maps.event.trigger(window.Map.markers[id], 'click');"
end

When 'I click on the news story titled "$title" in the list' do |title|
  selenium.js_eval "window.$('aside li h2:contains(#{title})').click()"
end

Then 'I see the news story titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("aside h2:contains(#{title})")
  assert_have_selector("#map *[title='#{title}']")
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