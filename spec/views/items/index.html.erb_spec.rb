require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/index.html.erb" do
  include ItemsHelper

  before(:each) do
    assigns[:items] = [
      stub_model(Item,
        :title => "value for title",
        :description => "value for description",
        :url => "value for url",
        :address => "value for address",
        :latitude => 1.5,
        :longitude => 1.5,
        :kind => "value for kind",
        :created_by_id => 1,
        :approved_by_id => 1
      ),
      stub_model(Item,
        :title => "value for title",
        :description => "value for description",
        :url => "value for url",
        :address => "value for address",
        :latitude => 1.5,
        :longitude => 1.5,
        :kind => "value for kind",
        :created_by_id => 1,
        :approved_by_id => 1
      )
    ]
  end

  it "renders a list of items" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", "value for url".to_s, 2)
    response.should have_tag("tr>td", "value for address".to_s, 2)
    response.should have_tag("tr>td", 1.5.to_s, 2)
    response.should have_tag("tr>td", 1.5.to_s, 2)
    response.should have_tag("tr>td", "value for kind".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
