require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

FM_PAGE_1 = `cat spec/lib/testData/lastfm/ottawa-page-1`
FM_PAGE_2 = `cat spec/lib/testData/lastfm/ottawa-page-2`
FM_PAGE_3 = `cat spec/lib/testData/lastfm/ottawa-page-3`
FM_BLAH_PAGE = `cat spec/lib/testData/lastfm/blahblah-feed`

describe LastfmRequest do
    it "should work with EST time zone" do
      xml = Nokogiri::XML <<-EOXML
      <event>
        <venue>
          <location>
            <timezone>EST</timezone>
          </location>
        </venue>
        <startDate>Mon, 30 Jun 2008</startDate>
        <startTime>20:00</startTime>
      </event>
      EOXML
      time = LastfmRequest.extract_start_time(xml)
      time.utc.should eql Time.gm(2008,7,1,01,00,00) # in UTC
    end

    it "should work with PST time zone" do
      xml = Nokogiri::XML <<-EOXML
      <event>
        <venue>
          <location>
            <timezone>PST</timezone>
          </location>
        </venue>
        <startDate>Mon, 30 Jun 2008</startDate>
        <startTime>20:00</startTime>
      </event>
      EOXML
      time = LastfmRequest.extract_start_time(xml)
      time.utc.should eql Time.gm(2008,7,1,04,00,00) # in UTC
    end

  it "should assume a length of 3 hours" do
    xml = Nokogiri::XML <<-EOXML
    <event>
      <venue>
        <location>
          <timezone>PST</timezone>
        </location>
      </venue>
      <startDate>Mon, 30 Jun 2008</startDate>
      <startTime>20:00</startTime>
    </event>
    EOXML
    start_time = LastfmRequest.extract_start_time(xml)
    end_time   = LastfmRequest.generate_end_time(xml)
    (start_time + 3.hours).should eql end_time
  end

  before(:all) do
    @today = Time.local(2009, 10, 8, 0, 0, 0)
  end

  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end

  it "should parse the correct values up to the middle of a single page" do
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1",
      :response => FM_PAGE_1)
    items = LastfmRequest.new(:start_date=>@today, :end_date=>Time.local(2009,10,11,0,0,0),
      :city=>'ottawa', :state =>'ontario', :country=>'CA').pull_items_from_service
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
    item.begin_at.should eql(Time.local(2009, 10, 10, 19, 0,0).utc)
    item.url.should eql('http://www.last.fm/event/1244803+Staggered+Crossing+at+Mavericks+on+10+October+2009')
    item.address.should eql("221 Rideau Street, Ottawa, Canada")
    item.kind.should eql('event')
  end

  it "should parse the correct values up to the middle of 2nd page" do
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1",
      :response => FM_PAGE_1)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2",
      :response => FM_PAGE_2)
    items = LastfmRequest .new(:start_date=>@today, :end_date=>Time.local(2009,10,15,0,0,0),
      :city=>'ottawa', :state =>'ontario', :country=>'CA').pull_items_from_service
    items.size.should eql 12

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
    
#    item = items.at(-1)
#    item.title.should eql("Kalle Mattson")
#    # FIXME: Also wrong due to DST
#    item.begin_at.should eql(Time.local(2009, 10, 15, 21, 0,0))
#    item.url.should eql('http://www.last.fm/event/1219409+Kalle+Mattson+at+Zaphod+Beeblebrox+on+15+October+2009')
#    item.address.should eql("27 York St., Ottawa, Canada")
#    item.kind.should eql('event')
  end

  it "should parse the correct values past when date goes past end of feed" do
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=1",
      :response => FM_PAGE_1)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=2",
      :response => FM_PAGE_2)
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=ottawa&api_key=b819d5a155749ad083fcd19407d4fc69&page=3",
      :response => FM_PAGE_3)
    items = LastfmRequest.new(:start_date=>@today, :end_date=>Time.local(2010,12,31,0,0,0),
      :city=>'ottawa', :state =>'ontario', :country=>'CA').pull_items_from_service

    items.size.should eql 30

    item = items.at(0)
    item.title.should eql("Daniel Wesley")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0))
    item.url.should eql('http://www.last.fm/event/1251131+Daniel+Wesley+at+Live+Lounge+on+8+October+2009')
    item.address.should eql("128.5 York St., Ottawa, Canada")
    item.kind.should eql('event')

    item = items.at(1)
    item.title.should eql("Karkwa")
    item.begin_at.should eql(Time.local(2009, 10, 8, 0, 0,0).utc)
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
    FakeWeb.register_uri(:get, "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=blahblah&api_key=b819d5a155749ad083fcd19407d4fc69&page=1",
      :response => FM_BLAH_PAGE)
    items = LastfmRequest.new(:start_date=>@today, :end_date=>Time.local(2010,12,31,0,0,0),
      :city=>'blahblah').pull_items_from_service

    items.size.should eql 0
  end

  describe "total pages" do

    before(:each) do
      @lastfm = LastfmRequest.new
      FakeWeb.register_uri(:get, @lastfm.url(1),
        :response => FM_PAGE_1)
    end

    it "should basically work" do
      @lastfm.total_pages.should eql(3)
    end

  end

  describe "location string" do
    before(:each) do
      @lastfm = LastfmRequest.new
    end

    it "should build the string if city is a term" do
      @lastfm.search_terms = {:city=>'ottawa'}
      @lastfm.location_string.should eql('ottawa')
    end

    it "should return the city and country if no region" do
      @lastfm.search_terms = {:city=>'ottawa', :country =>'CA',:state =>nil}
      @lastfm.location_string.should eql('ottawa,CA')
    end

    it "should not return the country if the region is specified" do
      @lastfm.search_terms = {:city=>'ottawa', :country=>'CA',:state =>'On'}
      @lastfm.location_string.should eql('ottawa')
    end

  end
end