require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe Lastfm do
  before(:all) do
    @today = Time.local(2009, 10, 8, 0, 0, 0)
  end

  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end

  it "should parse the correct values up to the middle of a single page" do
    page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,CA&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page1)
    loc = Location.new('ottawa', 'ontario', 'CA')
    items = Lastfm.get_items(loc, @today, Time.local(2009,10,11,0,0,0))

    items.size.should eql 9

    item = items.at(0)
    item.title.should eql("Daniel Wesley")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009')
    item.address.should eql("128.5 York St., Ottawa, Canada")
    item.kind.should eql('event')
    
    item = items.at(1)
    item.title.should eql("Karkwa")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1085723+Karkwa+at+Salle+Jean-Despr%C3%A9z+on+8+October+2009')
    item.address.should eql("25, rue Laurier, Gatineau, Québec, Canada")
    item.kind.should eql('event')

    item = items.at(-1)
    item.title.should eql("Staggered Crossing")
    # FIXME: This is wrong! Ruby is translating due to DST! XML says 20:00 not 21:00
    item.begin_at.should eql(Time.local(2009, 10, 10, 21, 0,0))
    item.url.should eql('http://www.last.fm/event/1244803+Staggered+Crossing+at+Mavericks+on+10+October+2009')
    item.address.should eql("221 Rideau Street, Ottawa, Canada")
    item.kind.should eql('event')
  end

  it "should parse the correct values up to the middle of 2nd page" do
    page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
    page2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,CA&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page1)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,CA&api_key=b819d5a155749ad083fcd19407d4fc69&page=2", 
                         :response => page2)
    loc = Location.new('ottawa', 'ontario', 'CA')
    items = Lastfm.get_items(loc, @today, Time.local(2009,10,15,23,59,0))

    items.size.should eql 13

    item = items.at(0)
    item.title.should eql("Daniel Wesley")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009')
    item.address.should eql("128.5 York St., Ottawa, Canada")
    item.kind.should eql('event')
    
    item = items.at(1)
    item.title.should eql("Karkwa")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1085723+Karkwa+at+Salle+Jean-Despr%C3%A9z+on+8+October+2009')
    item.address.should eql("25, rue Laurier, Gatineau, Québec, Canada")
    item.kind.should eql('event')

    item = items.at(-1)
    item.title.should eql("Kalle Mattson")
    # FIXME: Also wrong due to DST
    item.begin_at.should eql(Time.local(2009, 10, 15, 21, 0,0))
    item.url.should eql('http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009')
    item.address.should eql("27 York St., Ottawa, Canada")
    item.kind.should eql('event')
  end

  it "should parse the correct values past when date goes past end of feed" do
    page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
    page2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
    page3 = `cat spec/lib/testData/lastfm/ottawa-page-3`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,CA&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page1)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,CA&api_key=b819d5a155749ad083fcd19407d4fc69&page=2", 
                         :response => page2)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,CA&api_key=b819d5a155749ad083fcd19407d4fc69&page=3", 
                         :response => page3)
    loc = Location.new('ottawa', 'ontario', 'CA')
    items = Lastfm.get_items(loc, @today, Time.local(2010,12,31,0,0,0))

    items.size.should eql 30

    item = items.at(0)
    item.title.should eql("Daniel Wesley")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009')
    item.address.should eql("128.5 York St., Ottawa, Canada")
    item.kind.should eql('event')
    
    item = items.at(1)
    item.title.should eql("Karkwa")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1085723+Karkwa+at+Salle+Jean-Despr%C3%A9z+on+8+October+2009')
    item.address.should eql("25, rue Laurier, Gatineau, Québec, Canada")
    item.kind.should eql('event')

    item = items.at(-1)
    item.title.should eql("Corb Lund")
    item.begin_at.should eql(Time.local(2009,10,21,0,0,0))
    item.url.should eql('http://www.last.fm/event/1225889+Corb+Lund+at+The+New+Capital+Music+Hall+on+21+October+2009')
    item.address.should eql("128 York Street, Ottawa, Canada")
    item.kind.should eql('event')
  end

  it "should quit nicely if no concerts found at a location" do
    page1 = `cat spec/lib/testData/lastfm/blahblah-feed`
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=blahblah&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
                         :response => page1)
    loc = Location.new('blahblah', nil, nil)
    items = Lastfm.get_items(loc, @today, Time.local(2010,12,31,0,0,0))

    items.size.should eql 0
  end

  it "should come up with a reasonable start time if none specified"
  it "should have the right starting hour (issues with DST)"

# context "on initialize @loc" do
#   it "should be 'city,state' if given city, state, and country" do
#     #debugger
#     lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#     lastfm.loc.should eql 'ottawa,ontario'
#   end

#   it "should be 'city,state' if given just city and state" do
#     lastfm = Lastfm.new('ottawa', 'ontario', nil)
#     lastfm.loc.should eql 'ottawa,ontario'
#   end

#   it "should be 'state,country' if given just state and country" do
#     lastfm = Lastfm.new(nil, 'ontario', 'canada')
#     lastfm.loc.should eql 'ontario,canada'
#   end

#   it "should be 'city' if just given city" do
#     lastfm = Lastfm.new('ottawa', nil, nil)
#     lastfm.loc.should eql 'ottawa'
#   end

#   it "should be 'state' if just given state" do
#     lastfm = Lastfm.new(nil, 'ontario', nil)
#     lastfm.loc.should eql 'ontario'
#   end

#   it "should be 'country' if just given country" do
#     lastfm = Lastfm.new(nil, nil, 'canada')
#     lastfm.loc.should eql 'canada'
#   end
# end 

# it "should parse the feed and create items with the right values" do 
#   page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
#   page2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,ontario&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                        :response => page1)
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,ontario&api_key=b819d5a155749ad083fcd19407d4fc69&page=2", 
#                        :response => page2)
#   loc = Location.new('ottawa', 'ontario', 'CA')
#   items = Lastfm.get_items(loc, @today, Time.mktime(2010,12,31,0,0,0) )

#   item = items.at(0)
#   item.title.should eql("Daniel Wesley")
#   item.begin_at.should eql(Time.mktime(2009, 10, 8, 0, 0,0))
#   item.url.should eql('http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009')
#   item.address.should eql("128.5 York St., Ottawa, Canada")
#   #item.latitude.should be_close(45.4275148, 0.00001)
#   #item.longitude.should be_close(-75.694805, 0.00001)
#   item.kind.should eql('event')
#   
#   item = items.at(1)
#   item.title.should eql("Karkwa")
#   item.begin_at.should eql(Time.mktime(2009, 10, 8, 0, 0,0))
#   item.url.should eql('http://www.last.fm/event/1085723+Karkwa+at+Salle+Jean-Despr%C3%A9z+on+8+October+2009')
#   item.address.should eql("25, rue Laurier, Gatineau, Québec, Canada")
#   #item.latitude.should be_close(45.4776536, 0.00001)
#   #item.longitude.should be_close(-75.6458538, 0.00001)
#   item.kind.should eql('event')

#   item = items.at(-1)
#   item.title.should eql("The Scenics")
#   item.begin_at.should eql(Time.mktime(2009, 10, 14, 0, 0,0))
#   item.url.should eql('http://www.last.fm/event/1244079+The+Scenics+at+Zaphod+Beeblebrox+on+14+October+2009')
#   item.address.should eql("27 York St., Ottawa, Canada")
#   #item.latitude.should be_close(45.4278552, 0.00001)
#   #item.longitude.should be_close(-75.693986, 0.00001)
#   item.kind.should eql('event')
# end

# it "should create the right number of concerts for one day" do
#   lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#   # item1 and item2 should be saved, item3 should not be
#   item1 = Item.new( :title => "First concert",
#                     :begin_at => Time.mktime(2009, 10, 8, 0, 0, 0)
#                   )
#   item2 = Item.new( :title => "Second concert",
#                     :begin_at => Time.mktime(2009, 10, 8, 23, 59, 59)
#                   )
#   item3 = Item.new( :title => "Third concert",
#                     :begin_at => Time.mktime(2009, 10, 9, 0, 0, 1)
#                   )
#   Item.stub!(:new).and_return(item1, item2, item3)

#   item1.should_receive(:save).once
#   item2.should_receive(:save).once
#   item3.should_not_receive(:save)
#   lastfm.create_events_from_until(@today, @today + 1.day)
# end

# it "should create the right number of concerts for this week" do
#   lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#   item1 = Item.new( :title => "First concert",
#                     :begin_at => Time.mktime(2009, 10, 8, 0, 0, 0)
#                   )
#   item2 = Item.new( :title => "Second concert",
#                     :begin_at => Time.mktime(2009, 10, 14, 0, 0, 0)
#                   )
#   item3 = Item.new( :title => "Third concert",
#                     :begin_at => Time.mktime(2009, 10, 15, 0, 0, 1)
#                   )
#   Item.stub!(:new).and_return(item1, item2, item3)

#   item1.should_receive(:save).once
#   item2.should_receive(:save).once
#   item3.should_not_receive(:save)
#   lastfm.create_events_from_until(@today, @today + 7.days)
# end

# it "should save an item that begins after the start_date but before the end_date" do
#   test_item = Item.new(:title => "Kalle Mattson",
#            :begin_at => Time.mktime(2009, 10, 10, 20, 0),
#            :url => 'http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009',
#            :address => "27 York St., Ottawa, Canada",
#            :latitude => 45.427855, 
#            :longitude => -75.693986,
#            :kind => 'event'
#           )

#   lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#   lastfm.should_save?(test_item, @today, @today + 7.days).should be_true
# end

# it "should not save an item that is outside the specified dates" do
#   test_item = Item.new(:title => "Kalle Mattson",
#            :begin_at => Time.mktime(2009, 10, 25, 20, 0),
#            :url => 'http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009',
#            :address => "27 York St., Ottawa, Canada",
#            :latitude => 45.427855, 
#            :longitude => -75.693986,
#            :kind => 'event'
#           )

#   lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#   lastfm.should_save?(test_item, @today, @today + 7.days).should be_false
# end


# it "should recognize the current maximum pages for this location" do
#   page = `cat spec/lib/testData/lastfm/ottawa-page-1`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,canada&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                       :response => page)

#   lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#   lastfm.total_pages_of_feed_for_location.should eql(12)
# end

# it "should throw exception when the location doesn't exist" do
#   page = `cat spec/lib/testData/lastfm/blahblah-feed`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=blahblah,blahcountry&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                       :response => page)
#   page = `cat spec/lib/testData/lastfm/ottawa-page-1`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,canada&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                       :response => page)
#  
#   lastfm = Lastfm.new('blahblah', 'blahprov', 'blahcountry')
#   lambda {lastfm.location_exists?}.should raise_error(InvalidLocationException)
#   lastfm2 = Lastfm.new('ottawa', 'ontario', 'canada')
#   lambda {lastfm2.location_exists?}.should_not raise_error
# end

# it "should populate the queue with concerts from an xml page" do
#   page = `cat spec/lib/testData/lastfm/ottawa-page-1`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,canada&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                       :response => page)

#   lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#   lastfm.stub(:total_pages_of_feed_for_location).and_return(2)
#   Item.should_receive(:new).exactly(10).times
#   lastfm.populate_queue_with_items
#   lastfm.event_queue.length.should eql(10)
# end

# it "should keep giving next_concert over the feed page 1, page 2 boundary" do
#   page1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
#   page2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,canada&api_key=b819d5a155749ad083fcd19407d4fc69&page=1", 
#                        :response => page1)
#   FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,canada&api_key=b819d5a155749ad083fcd19407d4fc69&page=2", 
#                        :response => page2)
#   loc = Location.new('ottawa', 'ontario', 'CA')
#   items = Lastfm.get_items(loc, @today, Time.mktime(2010,12,31,0,0,0) )

#   # 10 events per page
#   lastfm.event_queue.empty?.should be_true
#   lastfm.stub(:total_pages_of_feed_for_location).and_return(2)
#   lastfm.next_concert.title.should eql("Daniel Wesley")
#   8.times { lastfm.next_concert }
#   lastfm.next_concert.title.should eql("The Scenics")
#   lastfm.next_concert.title.should eql("Silversun Pickups")
#   lastfm.next_concert.title.should eql("Hannah Georgas")

# end

# it "should create events having a start time"

# it "should keep adding events until end of feed if end_date is after the last xml event"

# it "should generate the api url when page is given" do
#   lastfm = Lastfm.new('ottawa', 'ontario', 'canada')
#   url = lastfm.generate_geo_api_url_page(2)
#   url.should eql("http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa,ontario&api_key=b819d5a155749ad083fcd19407d4fc69&page=2")
# end

end
