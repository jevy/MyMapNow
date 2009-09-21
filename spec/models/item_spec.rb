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

  it "should require end time to be after the beginning time" do
    item = Item.create(@valid_attributes.merge(:begin_at => 5.months.ago, :end_at => 10.months.ago))
    item.should_not be_valid
    item.should have(1).error_on(:end_at)
  end
end

describe "Bounded item finding" do
  before(:each) do
    @ottawa = Item.create(:title => 'Ottawa', :latitude => 45.420833,
                          :longitude => -75.69, :begin_at => 3.hours.from_now)
    
    @ottawa_old = Item.create(:title => 'Ottawa Old', :latitude => 45.420833,
                              :longitude => -75.69, :begin_at => 10.months.ago)
    
    @detroit = Item.create(:title => 'Detroit', :latitude => 42.3316,
                           :longitude => -83.0475, :begin_at => 4.hours.from_now)
  end

  it "should find ottawa in the given bounds" do
    items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703], 5.days.ago, 5.days.from_now)
    items.should include(@ottawa)
  end

  it "should not find detroit in the same bounds" do
    items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703], 5.days.ago, 5.days.from_now)
    items.should_not include(@detroit)
  end

  it "should not find items that are already ended"
  it "should find items that started before the bounds, but end inside the time bounds"
  it "should find items that both start and end outside the bounds"
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
