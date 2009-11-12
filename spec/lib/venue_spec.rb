require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Venue do

  it "should return the correct lat/log given a correct address" do
    loc = mock("location")
    loc.stub!(:coordinates).and_return([45.4409434, -75.6095398])
    geocoder = mock("geocoder")
    geocoder.stub!(:locate).and_return(loc)
    Graticule.stub_chain(:service, :new).and_return(geocoder)

    venue = Venue.new
    venue.city = "Ottawa"
    venue.state = "Ontario"
    venue.country = "Canada"
    venue.address = "1 Steel St."

    coords = venue.coordinates
    coords[0].should eql(45.4409434)
    coords[1].should eql(-75.6095398)
  end

  it "should return [0,0] for an incorrect address" do
    bad_address_venue = Venue.new
    bad_address_venue.name = "Bad Place"
    bad_address_venue.address = "Hwy 121"
    bad_address_venue.city = "Kinmount"
    bad_address_venue.state = "ON"

    bad_address_venue.coordinates.should eql([0,0])
  end

  it "should create a full address when all values present" do
    venue = Venue.new
    venue.name = "Cool Place"
    venue.city = "Ottawa"
    venue.state = "Ontario"
    venue.country = "Canada"
    venue.address = "1 Steel St."

    expected_full_address = "1 Steel St., Ottawa, Ontario, Canada"
    venue.full_address.should eql(expected_full_address)
  end

  it "should create a full address when country value is not present" do
    venue = Venue.new
    venue.name = "Cool Place"
    venue.city = "Ottawa"
    venue.state = "Ontario"
    venue.country = "Canada"
    venue.address = "1 Steel St."

    expected_full_address = "1 Steel St., Ottawa, Ontario, Canada"
    venue.country = ""
    venue.full_address.should eql("1 Steel St., Ottawa, Ontario")
  end
end
