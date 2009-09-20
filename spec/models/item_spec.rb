require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @valid_attributes = {
      :title => "Prime Minister's Residence",
      :begin_at => Time.mktime(1983, 3, 22, 15, 35, 0),
      :latitude => 45.444363,
      :longitude => -75.693811,
      :address => '24 Sussex Dr., Ottawa, ON, Canada'
    }
    
    Geocoder.stub!(:locate => stub(:latitude => 0, :longitude => 0))
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

  it "should require a latitude and longitude, or an address" do
    item = Item.create(@valid_attributes.merge(:latitude => nil, :longitude => nil, :address => nil))
    item.should_not be_valid
    item.should have(1).error_on(:latitude)
    item.should have(1).error_on(:longitude)
    item.should have(1).error_on(:address)
  end

  it "should not require lat/lng if an address is provided" do
    item = Item.create(@valid_attributes.merge(:latitude => nil, :longitude => nil))
    item.should be_valid
  end

  it "should not require an address if if lat/lng are provided" do
    item = Item.create(@valid_attributes.merge(:address => nil))
    item.should be_valid
  end
end

describe "Item Geocoding" do
  before(:each) do
    @valid_attributes = {
      :title => "Prime Minister's Residence",
      :begin_at => Time.mktime(1983, 3, 22, 15, 35, 0),
      :latitude => 45.444363,
      :longitude => -75.693811,
      :address => '24 Sussex Dr., Ottawa, ON, Canada'
    }
  end

  it "should geocode an address if provided" do
    geocoder = stub(:latitude => @valid_attributes[:latitude], :longitude => @valid_attributes[:longitude])
    Geocoder.should_receive(:locate).with(@valid_attributes[:address]).and_return(geocoder)
    item = Item.create(@valid_attributes.merge(:latitude => nil, :longitude => nil))
    item.latitude.should == @valid_attributes[:latitude]
    item.longitude.should == @valid_attributes[:longitude]
  end

  it "should not geocode if latitude and longitude are provided" do
    Geocoder.should_not_receive(:locate)
    item = Item.create(@valid_attributes)
  end

  it "should require valid geocodeable address"
  it "should require sensible latitude and longitude"
  it "should possibly reverse geocode (get address for lat/lng)"
end
