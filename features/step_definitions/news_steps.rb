Given 'a news story in $location titled "$title"' do |location, title|
  l = LOCATIONS[location]
  Geocode.geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude
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