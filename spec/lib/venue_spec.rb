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

  it "should get a geocoder when getting coordinates()" do
  end

  # TODO: This uses the internet.  Is that bad?
  it "should return the correct lat/log given a correct address" do
    #@venue.coordinates.should eql @expected_coordinates
  end

  # TODO: This uses the internet.  Is that bad?
  it "should return nil given an inaccurate (or wrong) address" do
    #@venue.address = "1234 Silly Willy St."
    #@venue.coordinates.should eql nil
  end

  it "should return true if the accuracy is too low"

  it "should create a full address when all values present" do
    @venue.full_address.should eql @expected_full_address
  end

  it "should not create a full address when a value is not present" do
    @venue.address = nil
    @venue.full_address.should eql ""
  end
end
