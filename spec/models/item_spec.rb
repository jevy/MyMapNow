require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :begin_at => Time.now,
      :end_at => Time.now,
      :url => "value for url",
      :address => "value for address",
      :latitude => 1.5,
      :longitude => 1.5,
      :kind => "value for kind",
      :created_by_id => 1,
      :approved_by_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Item.create!(@valid_attributes)
  end
end
