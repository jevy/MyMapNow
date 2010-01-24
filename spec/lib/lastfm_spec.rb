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
    items = LastfmRequest.new(:start_date=>@today, :end_date=>Time.local(2009,10,11,0,0,0),
      :city=>'ottawa', :region=>'ontario', :country=>'CA').pull_items_from_service

    
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
    items = LastfmRequest.new(:start_date=>@today, :end_date=>Time.local(2009,10,11,0,0,0),
      :city=>'ottawa', :region=>'ontario', :country=>'CA').pull_items_from_service
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
    items = LastfmRequest.new(:start_date=>@today, :end_date=>Time.local(2010,12,31,0,0,0),
      :city=>'ottawa', :region=>'ontario', :country=>'CA').pull_items_from_service

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
    items = LastfmRequest.new(:start_date=>@today, :end_date=>Time.local(2010,12,31,0,0,0),
    :city=>'blahblah', :region=>nil, :country=>nil).pull_items_from_service

    items.size.should eql 0
  end
end
