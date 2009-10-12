require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe Lastfm do

it "should create today concerts"
#   page = `cat spec/lib/testData/lastfm/ottawa-page-1`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                        :response => page)
#   lastfm = Lastfm.new('ottawa')
#   # Total of 5 events on Thursday, Oct 8th
#   Item.should_receive(:create).with(:title => "Daniel Wesley",
#                                     :begin_at => Time.mktime(2009, 10, 8, 0, 0,0),
#                                     :url => 'http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009',
#                                     :address => "128.5 York St., Ottawa, Canada",
#                                     :latitude => 45.4275148, 
#                                     :longitude => -75.694805,
#                                     :kind => 'event'
#                                   )
#   Item.should_receive(:create).exactly(4).times
#   lastfm.create_events_for_next_days_in('ottawa', 1)

it "should create the next week's concerts from the xml feed"
#   page = `cat spec/lib/testData/lastfm/ottawa-page-1`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                        :response => page)
#   lastfm = Lastfm.new
#   # Total of 15 events
#   Item.should_receive(:create).exactly(14).times
#   Item.should_receive(:create).with(:title => "Kalle Mattson",
#                                     :begin_at => Time.mktime(2009, 10, 15, 20, 0),
#                                     :url => 'http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009',
#                                     :address => "27 York St., Ottawa, Canada",
#                                     :latitude => 45.427855, 
#                                     :longitude => -75.693986,
#                                     :kind => 'event'
#                                   )
#   lastfm.create_events_for_next_days_in('ottawa', 7)
# end

  it "should recognize the current maximum pages for this location" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)

    lastfm = Lastfm.new('ottawa')
    lastfm.total_pages_of_feed_for_location.should eql 12
  end

  it "should fail nicely when the location doesn't exist" do
    page = `cat spec/lib/testData/lastfm/blahblah-feed`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=blahblah&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)
   
    lastfm = Lastfm.new('blahblah')
    lastfm.create_events_for_next_days_in('ottawa', 7)
  end

  it "should return nil for total pages if the location is not found" do
    page = `cat spec/lib/testData/lastfm/blahblah-feed`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=blahblah&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)

    lastfm = Lastfm.new('blahblah')
    lastfm.total_pages_of_feed_for_location.should eql nil
  end

  it "should create events without a start time" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)
    lastfm = Lastfm.new('ottawa')
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

  it "should create events having a start time"

  it "should generate the api url when page is given" do
    lastfm = Lastfm.new('ottawa')
    url = lastfm.generate_geo_api_url_page(2)
    url.should eql "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2"
  end

  it "should have a venue and an event name"

end
