require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @valid_attributes = {
      :title => "Prime Minister's Residence",
      :begin_at => Time.mktime(1983, 3, 22, 15, 35, 0),
      :latitude => 45.444363,
      :longitude => -75.693811
    }
  end

  it "should create a new instance given valid attributes" do
    Item.create(@valid_attributes).should be_valid
  end

  it "should require a title" do
    item = Item.create(@valid_attributes.merge(:title => nil))
    item.should_not be_valid
    item.should have(1).error_on(:title)
  end

  it "should require a start time" do
    item = Item.create(@valid_attributes.merge(:begin_at => nil))
    item.should_not be_valid
    item.should have(1).error_on(:begin_at)
  end

  it "should require a latitude" do
    item = Item.create(@valid_attributes.merge(:latitude => nil))
    item.should_not be_valid
    item.should have(1).error_on(:latitude)
  end

  it "should require a longitude" do
    item = Item.create(@valid_attributes.merge(:longitude => nil))
    item.should_not be_valid
    item.should have(1).error_on(:longitude)
  end
end
