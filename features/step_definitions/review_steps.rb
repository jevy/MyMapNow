def time_from_string(string)
  eval(string.gsub(" ", '.'))
end

Given 'a review in $location titled "$title" in $date' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocode.geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "review", :begin_at => time_from_string(timeframe).from_now
end

Given 'a review in $location titled "$title" $date ago' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocode.geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "review", :begin_at => time_from_string(timeframe).ago
end

Then 'I see the review titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("aside li.event h2:contains(#{title})")
  assert_have_selector("#map *[title='#{title}']")
end

Then 'I do not see the review titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_no_selector("aside li.event h2:contains(#{title})")
  assert_have_no_selector("#map *[title='#{title}']")
end
