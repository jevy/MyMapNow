require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Venue do
  before(:each) do
    @venue = Venue.new
    @venue.name = "Cool Place"
    @venue.city = "Ottawa"
    @venue.state = "Ontario"
    @venue.address = "1 Steel St."

    @expected_full_address = "1 Steel St., Ottawa, Ontario"
    @expected_coordinates = [45.4409439, -75.6095409]
  end

  # TODO: This uses the internet.  Is that bad?
  it "should return the correct lat/log given a correct address" do
    @venue.coordinates.should eql @expected_coordinates
  end

  it "should return [0,0] for an incorrect address" do
    @bad_address_venue = Venue.new
    @bad_address_venue.name = "Bad Place"
    @bad_address_venue.address = "Hwy 121"
    @bad_address_venue.city = "Kinmount"
    @bad_address_venue.state = "ON"

    @bad_address_venue.coordinates.should eql [0,0]
  end

  # TODO: This uses the internet.  Is that bad?
  it "should return nil given an inaccurate (or wrong) address" do
    #@venue.address = "1234 Silly Willy St."
    #@venue.coordinates.should eql nil
  end

  it "should create a full address when all values present" do
    @venue.full_address.should eql @expected_full_address
  end

  it "should not create a full address when a value is not present" do
    @venue.address = nil
    @venue.full_address.should eql ""
  end

end
