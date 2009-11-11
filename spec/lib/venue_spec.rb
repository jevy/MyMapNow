require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Venue do
  before(:each) do
    @venue = Venue.new
    @venue.name = "Cool Place"
    @venue.city = "Ottawa"
    @venue.state = "Ontario"
    @venue.country = "Canada"
    @venue.address = "1 Steel St."

    @expected_full_address = "1 Steel St., Ottawa, Ontario, Canada"
    @expected_coordinates = [45.4409434, -75.6095398]
  end

  # TODO: This uses the internet.  Is that bad?
  it "should return the correct lat/log given a correct address" do
    coords = @venue.coordinates
    coords[0].should be_close(45.4409434, 0.00001)
    coords[1].should be_close(-75.6095398, 0.00001)
  end

  it "should return [0,0] for an incorrect address" do
    @bad_address_venue = Venue.new
    @bad_address_venue.name = "Bad Place"
    @bad_address_venue.address = "Hwy 121"
    @bad_address_venue.city = "Kinmount"
    @bad_address_venue.state = "ON"

    @bad_address_venue.coordinates.should eql([0,0])
  end

  it "should create a full address when all values present" do
    @venue.full_address.should eql(@expected_full_address)
  end

  it "should create a full address when address value is not present" do
    @venue.address = ""
    @venue.full_address.should eql("Ottawa, Ontario, Canada")
  end

  it "should create a full address when state value is not present" do
    @venue.state = ""
    @venue.full_address.should eql("1 Steel St., Ottawa, Canada")
  end

  it "should create a full address when country value is not present" do
    @venue.country = ""
    @venue.full_address.should eql("1 Steel St., Ottawa, Ontario")
  end
end
