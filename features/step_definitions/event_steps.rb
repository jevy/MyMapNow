def time_from_string(string)
  eval(string.gsub(" ", '.'))
end

Given 'an event in $location titled "$title" in $date' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocode.geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "event", :begin_at => time_from_string(timeframe).from_now
end

Given 'an event in $location titled "$title" $date ago' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocode.geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "event", :begin_at => time_from_string(timeframe).ago
end

When 'I set "$field" to $timeframe from now' do |field, timeframe|
  fill_in field, :with => time_from_string(timeframe).from_now.strftime("%Y-%m-%d")
end

Then 'I see the event titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("aside li.event h2:contains(#{title})")
  assert_have_selector("#map *[title='#{title}']")
end

Then 'I do not see the event titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_no_selector("aside li.event h2:contains(#{title})")
  assert_have_no_selector("#map *[title='#{title}']")
end