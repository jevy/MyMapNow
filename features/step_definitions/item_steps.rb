When 'I click to submit a new item' do
  click_link 'Submit News'
end

When 'I save the item' do
  click_button 'Save'
  selenium.wait_for_page
end

Then 'I see the new item form' do
  assert_have_selector("form[action=#{items_path}][method=post]")
end
