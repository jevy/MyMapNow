require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/edit.html.erb" do
  include ItemsHelper

  before(:each) do
    assigns[:item] = @item = stub_model(Item,
      :new_record? => false,
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

  it "renders the edit item form" do
    render

    response.should have_tag("form[action=#{item_path(@item)}][method=post]") do
      with_tag('input#item_title[name=?]', "item[title]")
      with_tag('textarea#item_description[name=?]', "item[description]")
      with_tag('input#item_url[name=?]', "item[url]")
      with_tag('input#item_address[name=?]', "item[address]")
      with_tag('input#item_latitude[name=?]', "item[latitude]")
      with_tag('input#item_longitude[name=?]', "item[longitude]")
      with_tag('input#item_kind[name=?]', "item[kind]")
      with_tag('input#item_created_by_id[name=?]', "item[created_by_id]")
      with_tag('input#item_approved_by_id[name=?]', "item[approved_by_id]")
    end
  end
end
