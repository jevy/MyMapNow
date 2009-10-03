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

  it "should geocode the address" do
  # my_graticule = mock("Graticule")
  # my_geocoder = mock("geocoder")
  # my_graticule.should_receive(:service)

  # my_graticule.should_receive(:service)
  # #my_graticule.should_receive(:locate).with(@expected_full_address).and_return(@expected_coordinates)
  # #@venue.coordinates.should eql @expected_coordinates
  end

  it "should create a full address when all values present" do
    @venue.full_address.should eql @expected_full_address
  end

  it "should not create a full address when a value is not present" do
    @venue.address = nil
    @venue.full_address.should eql ""
  end
end
