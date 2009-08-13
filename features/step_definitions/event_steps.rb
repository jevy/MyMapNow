def time_from_string(string)
  eval(string.gsub(" ", '.'))
end

Given 'an event in $location titled "$title" in $date' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "event", :begin_at => time_from_string(timeframe).from_now
end

Given 'an event in $location titled "$title" $date ago' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "event", :begin_at => time_from_string(timeframe).ago
end

When 'I set "$field" to $timeframe from now' do |field, timeframe|
  fill_in field, :with => time_from_string(timeframe).from_now.strftime("%Y-%m-%d")
end
