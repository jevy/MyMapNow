When 'I click to submit a new item' do
  click_link 'Submit News/Events'
end

Then 'I see the new item form' do
  selenium.wait_for_ajax :javascript_framework => :jquery
  assert_have_selector("form[action=#{items_path}][method=post]")
end
