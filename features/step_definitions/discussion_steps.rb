Given 'a discussion in $location titled "$title"' do |location, title|
  l = LOCATIONS[location]
  Geocoder.responses << l
  i = Item.create :title => title, 
    :latitude => l.latitude, :longitude => l.longitude, :kind => 'discussion', 
    :begin_at => 30.minutes.ago
  i.conversations << Conversation.new(:email => 'sam@example.com', :author => 'Sam Body', :message => 'Hello world.')
end

Then 'I see the discussion comment "$comment" by "$author"' do |comment, author|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("aside li.discussion .conversation *:contains(#{comment})")
  assert_have_selector("aside li.discussion .conversation *:contains(#{author})")
end