require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

# Handy to drop in
#require "rubygems"; require "ruby-debug"; debugger

describe Lastfm do
  before(:all) do
    @today = Time.mktime(2009, 10, 8, 0, 0, 0)
  end

  it "should parse the feed and create items with the right values" do 
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page)
    lastfm = Lastfm.new('ottawa')
    # Total of 5 events on Thursday, Oct 8th.  10 on the feed's page 1
    Item.should_receive(:new).with(:title => "Daniel Wesley",
                                      :begin_at => Time.mktime(2009, 10, 8, 0, 0,0),
                                      :url => 'http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009',
                                      :address => "128.5 York St., Ottawa, Canada",
                                      :latitude => 45.4275148, 
                                      :longitude => -75.694805,
                                      :kind => 'event'
                                    )
    Item.should_receive(:new).with(:title => "Karkwa",
                                      :begin_at => Time.mktime(2009, 10, 8, 0, 0,0),
                                      :url => 'http://www.last.fm/event/1085723+Karkwa+at+Salle+Jean-Despr%C3%A9z+on+8+October+2009',
                                      :address => "25, rue Laurier, Gatineau, Québec, Canada",
                                      :latitude => 45.428066, 
                                      :longitude => -75.710447,
                                      :kind => 'event'
                                    )
    Item.should_receive(:new).with(:title => "The Dirty 30's",
                                      :begin_at => Time.mktime(2009, 10, 8, 0, 0,0),
                                      :url => 'http://www.last.fm/event/1253837+The+Dirty+30%27s+at+Zaphod+Beeblebrox+on+8+October+2009',
                                      :address => "27 York St., Ottawa, Canada",
                                      :latitude => 45.427855, 
                                      :longitude => -75.693986,
                                      :kind => 'event'
                                    )
    Item.should_receive(:new).exactly(6).times
    Item.should_receive(:new).with(:title => "The Scenics",
                                      :begin_at => Time.mktime(2009, 10, 14, 0, 0,0),
                                      :url => 'http://www.last.fm/event/1244079+The+Scenics+at+Zaphod+Beeblebrox+on+14+October+2009',
                                      :address => "27 York St., Ottawa, Canada",
                                      :latitude => 45.427855, 
                                      :longitude => -75.693986,
                                      :kind => 'event'
                                    )
    lastfm.create_events_from_until(@today, @today + 1.day)
  end

  it "should create the right number of concerts for today(from midnight to midnight)" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page)
    lastfm = Lastfm.new('ottawa')
    # Total of 5 events on Thursday, Oct 8th.  10 on the feed's page 1
    my_item = mock("item")
    my_item.should_receive(:save).exactly(5).times
    lastfm.create_events_from_until(@today, @today + 1.day)
  end

  it "should create the right number of concerts for this week" do
    page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
    page2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page1)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2", 
                         :response => page2)
    lastfm = Lastfm.new('ottawa')
    # Total of 15 events
    my_item = mock('item')
    my_item.should_receive(:save).exactly(15).times
    lastfm.create_events_from_until(@today, @today + 7.days)
  end

  it "should save an item that begins after the start_date but before the end_date" do
    test_item = Item.new(:title => "Kalle Mattson",
             :begin_at => Time.mktime(2009, 10, 10, 20, 0),
             :url => 'http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009',
             :address => "27 York St., Ottawa, Canada",
             :latitude => 45.427855, 
             :longitude => -75.693986,
             :kind => 'event'
            )

    lastfm = Lastfm.new('ottawa')
    lastfm.should_save?(test_item, @today, @today + 7.days).should be_true
  end

  it "should not save an item that is outside the specified dates" do
    test_item = Item.new(:title => "Kalle Mattson",
             :begin_at => Time.mktime(2009, 10, 25, 20, 0),
             :url => 'http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009',
             :address => "27 York St., Ottawa, Canada",
             :latitude => 45.427855, 
             :longitude => -75.693986,
             :kind => 'event'
            )

    lastfm = Lastfm.new('ottawa')
    lastfm.should_save?(test_item, @today, @today + 7.days).should be_false
  end


  it "should recognize the current maximum pages for this location" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)

    lastfm = Lastfm.new('ottawa')
    lastfm.total_pages_of_feed_for_location.should eql 12
  end

  it "should throw exception when the location doesn't exist" do
    page = `cat spec/lib/testData/lastfm/blahblah-feed`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=blahblah&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)
   
    lastfm = Lastfm.new('blahblah').should raise_error
    lastfm2 = Lastfm.new('ottawa').should_not raise_error
  end

  it "should populate the queue with concerts from an xml page" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)

    lastfm = Lastfm.new('ottawa')
    lastfm.stub(:total_pages_of_feed_for_location).and_return(2)
    Item.should_receive(:new).exactly(10).times
    lastfm.populate_queue_with_items
    lastfm.event_queue.length.should eql 10
  end

  it "should have populate_queue_with_items return nil if no more events to load" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)

    lastfm = Lastfm.new('ottawa')
    lastfm.stub(:total_pages_of_feed_for_location).and_return(1)
    lastfm.populate_queue_with_items.should eql 10 # Loaded first page succesfully
    lastfm.populate_queue_with_items.should eql 0
  end

  it "should keep giving next_concert over the feed page 1, page 2 boundary" do
    page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
    page2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page1)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2", 
                         :response => page2)
    lastfm = Lastfm.new('ottawa')

    # 10 events per page
    lastfm.event_queue.empty?.should eql true
    lastfm.stub(:total_pages_of_feed_for_location).and_return(2)
    lastfm.next_concert.title.should eql "Daniel Wesley"
    8.times { lastfm.next_concert }
    lastfm.next_concert.title.should eql "The Scenics"
    lastfm.next_concert.title.should eql "Silversun Pickups"
    lastfm.next_concert.title.should eql "Hannah Georgas"

  end

  it "should create events having a start time"

  it "should keep adding events until end of feed"

  it "should generate the api url when page is given" do
    lastfm = Lastfm.new('ottawa')
    url = lastfm.generate_geo_api_url_page(2)
    url.should eql "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2"
  end

end
