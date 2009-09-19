require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/show.html.erb" do
  include ItemsHelper
  before(:each) do
    assigns[:item] = @item = stub_model(Item,
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
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/value\ for\ url/)
    response.should have_text(/value\ for\ address/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/value\ for\ kind/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
