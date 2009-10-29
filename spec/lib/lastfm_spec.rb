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
    lastfm.populate_queue_with_items
    queue = lastfm.event_queue

    item = queue.pop
    item.title.should eql("Daniel Wesley")
    item.begin_at.should eql(Time.mktime(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009')
    item.address.should eql("128.5 York St., Ottawa, Canada")
    item.latitude.should eql(45.4275148)
    item.longitude.should eql(-75.694805)
    item.kind.should eql('live_music')
    
    item = queue.pop
    item.title.should eql("Karkwa")
    item.begin_at.should eql(Time.mktime(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1085723+Karkwa+at+Salle+Jean-Despr%C3%A9z+on+8+October+2009')
    item.address.should eql("25, rue Laurier, Gatineau, Québec, Canada")
    item.latitude.should eql(45.4776536)
    item.longitude.should eql(-75.6458538)
    item.kind.should eql('live_music')

    7.times { queue.pop }
      
    item = queue.pop
    item.title.should eql("The Scenics")
    item.begin_at.should eql(Time.mktime(2009, 10, 14, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1244079+The+Scenics+at+Zaphod+Beeblebrox+on+14+October+2009')
    item.address.should eql("27 York St., Ottawa, Canada")
    item.latitude.should eql(45.4278552)
    item.longitude.should eql(-75.693986)
    item.kind.should eql('live_music')

    queue.empty?.should be_true
    
    lastfm.create_events_from_until(@today, @today + 1.day)
  end

  it "should create the right number of concerts for one day" do
    lastfm = Lastfm.new('ottawa')
    # item1 and item2 should be saved, item3 should not be
    item1 = Item.new( :title => "First concert",
                      :begin_at => Time.mktime(2009, 10, 8, 0, 0, 0)
                    )
    item2 = Item.new( :title => "Second concert",
                      :begin_at => Time.mktime(2009, 10, 8, 23, 59, 59)
                    )
    item3 = Item.new( :title => "Third concert",
                      :begin_at => Time.mktime(2009, 10, 9, 0, 0, 1)
                    )
    Item.stub!(:new).and_return(item1, item2, item3)

    item1.should_receive(:save).once
    item2.should_receive(:save).once
    item3.should_not_receive(:save)
    lastfm.create_events_from_until(@today, @today + 1.day)
  end

  it "should create the right number of concerts for this week" do
    lastfm = Lastfm.new('ottawa')
    item1 = Item.new( :title => "First concert",
                      :begin_at => Time.mktime(2009, 10, 8, 0, 0, 0)
                    )
    item2 = Item.new( :title => "Second concert",
                      :begin_at => Time.mktime(2009, 10, 14, 0, 0, 0)
                    )
    item3 = Item.new( :title => "Third concert",
                      :begin_at => Time.mktime(2009, 10, 15, 0, 0, 1)
                    )
    Item.stub!(:new).and_return(item1, item2, item3)

    item1.should_receive(:save).once
    item2.should_receive(:save).once
    item3.should_not_receive(:save)
    lastfm.create_events_from_until(@today, @today + 7.days)
  end

  it "should save an item that begins after the start_date but before the end_date" do
    test_item = Item.new(:title => "Kalle Mattson",
             :begin_at => Time.mktime(2009, 10, 10, 20, 0),
             :url => 'http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009',
             :address => "27 York St., Ottawa, Canada",
             :latitude => 45.427855, 
             :longitude => -75.693986,
             :kind => 'live_music'
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
             :kind => 'live_music'
            )

    lastfm = Lastfm.new('ottawa')
    lastfm.should_save?(test_item, @today, @today + 7.days).should be_false
  end


  it "should recognize the current maximum pages for this location" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)

    lastfm = Lastfm.new('ottawa')
    lastfm.total_pages_of_feed_for_location.should eql(12)
  end

  it "should throw exception when the location doesn't exist" do
    page = `cat spec/lib/testData/lastfm/blahblah-feed`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=blahblah&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)
   
    lastfm = lambda {Lastfm.new('blahblah')}.should raise_error(InvalidLocationException)
    lastfm2 = lambda {Lastfm.new('ottawa')}.should_not raise_error
  end

  it "should populate the queue with concerts from an xml page" do
    page = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                        :response => page)

    lastfm = Lastfm.new('ottawa')
    lastfm.stub(:total_pages_of_feed_for_location).and_return(2)
    Item.should_receive(:new).exactly(10).times
    lastfm.populate_queue_with_items
    lastfm.event_queue.length.should eql(10)
  end

 #it "should have populate_queue_with_items return nil if no more events to load" do
 #  page = `cat spec/lib/testData/lastfm/ottawa-page-1`
 #  FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
 #                      :response => page)

 #  lastfm = Lastfm.new('ottawa')
 #  lastfm.stub(:total_pages_of_feed_for_location).and_return(1)
 #  lastfm.populate_queue_with_items.should eql 10 # Loaded first page succesfully
 #  lastfm.populate_queue_with_items.should eql 0
 #end

  it "should keep giving next_concert over the feed page 1, page 2 boundary" do
    page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
    page2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page1)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2", 
                         :response => page2)
    lastfm = Lastfm.new('ottawa')

    # 10 events per page
    lastfm.event_queue.empty?.should be_true
    lastfm.stub(:total_pages_of_feed_for_location).and_return(2)
    lastfm.next_concert.title.should eql("Daniel Wesley")
    8.times { lastfm.next_concert }
    lastfm.next_concert.title.should eql("The Scenics")
    lastfm.next_concert.title.should eql("Silversun Pickups")
    lastfm.next_concert.title.should eql("Hannah Georgas")

  end

  it "should create events having a start time"

  it "should keep adding events until end of feed if end_date is after the last xml event"

  it "should generate the api url when page is given" do
    lastfm = Lastfm.new('ottawa')
    url = lastfm.generate_geo_api_url_page(2)
    url.should eql("http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2")
  end

end
