require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meetup do
  before(:all) do
    @today = Time.mktime(2009, 10, 20 , 0, 0, 0)
  end

  it "should grab events for the next day"
  it "should grab events for the next week"

  it "should parse the XML into expected values" do
    meetup = Meetup.new('ca', 'ottawa')
    meetup.create_events_from_until(@today, @today + 1.day)
    
  end

end

