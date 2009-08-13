def time_from_string(string)
  eval(string.gsub(" ", '.'))
end

Given 'a review in $location titled "$title" in $date' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "review", :begin_at => time_from_string(timeframe).from_now
end

Given 'a review in $location titled "$title" $date ago' do |location, title, timeframe|
  l = LOCATIONS[location]
  Geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => "review", :begin_at => time_from_string(timeframe).ago
end
