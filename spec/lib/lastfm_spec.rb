require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe Lastfm do
  it "should access the first 'x' pagination of the xml feed"
  it "should create some events from the xml page"
   #lastfm = Lastfm.new
   #events = lastfm.get_local_events_for('ottawa')
   #Item.should_receive(:create).exactly(5).times
   #lastfm.create_events(events)

  it "should generate the api url when page is given" do
    lastfm = Lastfm.new
    url = lastfm.generate_geo_api_url("geo.getEvents", 'ottawa', 2)
    url.should eql "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2"
  end

end
