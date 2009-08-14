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

Then '"$title" has been approved' do |title|
  selenium.wait_for_ajax :javascript_framework => :jquery
  item = Item.find(:first, :conditions => {:title => title})
  assert_not_nil item.approved_by
end