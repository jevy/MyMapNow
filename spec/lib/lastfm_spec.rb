require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe Lastfm do

  it "should access the first 'x' pagination of the xml feed"

  it "should create some events without start time from the xml page" do
   page = `cat spec/lib/testData/lastfm/ottawa-page-1`
   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)
   lastfm = Lastfm.new
   Item.should_receive(:create).with(:title => "Daniel Wesley",
                                     :begin_at => Time.mktime(2009, 10, 8, 0, 0,0),
                                     :url => 'http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009',
                                     :address => "128.5 York St., Ottawa, Canada",
                                     :latitude => 45.4275148, 
                                     :longitude => -75.694805,
                                     :kind => 'event'
                                    )
   Item.should_receive(:create).exactly(9).times
   lastfm.geo_get_events('ottawa')
  end

  it "should create not having a start time, only start date"

  it "should generate the api url when page is given" do
    lastfm = Lastfm.new
    url = lastfm.generate_geo_api_url('ottawa', 2)
    url.should eql "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2"
  end

  it "should have a venue and an event name"

end
