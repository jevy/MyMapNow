Given 'a news story in $location titled "$title"' do |location, title|
  Item.create :title => title
end

Then 'I see the news story titled "$title"' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("h2:contains(#{title})")
end