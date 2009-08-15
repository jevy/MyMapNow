Given '"$title" is unapproved' do |title|
  item = Item.find(:first, :conditions => {:title => title})
  item.approved_by = nil
  item.save
end

When 'I click to submit a new item' do
  click_link 'Submit News'
end

When 'I save the item' do
  selenium.js_eval "window.$('button:content(Save)').click()"
end

When 'I click on the $kind titled "$title" on the map' do |kind, title|
  selenium.js_eval "var marker = window.$('aside li.#{kind} h2:contains(#{title}):first').parent().data('marker');
    window.google.maps.event.trigger(marker, 'click');"
end

When 'I click on the $kind titled "$title" in the list' do |kind, title|
  selenium.js_eval "window.$('aside li.#{kind} h2:contains(#{title})').click()"
end


Then 'I see the new item form' do
  assert_have_selector("form[action=#{items_path}][method=post]")
end

Then 'I see the $kind titled "$title"' do |kind, title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("aside li.#{kind} h2:contains(#{title})")
  assert_have_selector("#map *[title='#{title}']")
end

Then 'I do not see the $kind titled "$title"' do |kind, title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_no_selector("aside li.#{kind} h2:contains(#{title})")
  assert_have_no_selector("#map *[title='#{title}']")
end

Then 'I see the $kind titled "$title" once' do |kind, title|
  pending
  Then %Q{I see the news story titled "#{title}"}
  assert_have_selector("aside li.#{kind} h2:contains(#{title}):lt(1)")
  assert_have_selector("#map *[title='#{title}']:lt(1)")
  
  assert_have_no_selector("aside li.#{kind} h2:contains(#{title}):gt(0)")
  assert_have_no_selector("#map *[title='#{title}']:gt(0)")
end

Then 'I see the $kind titled "$title" highlighted on the map' do |kind, title|
  assert_have_selector("#map h2:contains(#{title})")
end

Then 'I see the $kind titled "$title" highlighted in the list' do |kind, title|
  assert_have_selector("aside li.#{kind}.active h2:contains(#{title})")
end

Then 'I see the $kind titled "$title" is not highlighted' do |kind, title|
  assert_have_no_selector("aside li.#{kind}.active h2:contains(#{title})")
  assert_have_no_selector("#map h2:contains(#{title})")
end

Then '"$title" has been approved' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  item = Item.find(:first, :conditions => {:title => title})
  assert_not_nil item.approved_by
end