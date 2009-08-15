Given 'a news story in $location titled "$title"' do |location, title|
  l = LOCATIONS[location]
  Geocoder.responses << l
  Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => 'news', 
    :begin_at => 3.days.from_now
end
