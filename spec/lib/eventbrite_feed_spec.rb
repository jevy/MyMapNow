require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

COUNT_ONLY_PAGE = 'spec/lib/testData/eventbrite/count.xml'
LOW_COUNT = 'spec/lib/testData/eventbrite/count_1.xml'
FULL_PAGE = 'spec/lib/testData/eventbrite/full_page.xml'
VENUE = 'spec/lib/testData/eventbrite/venue.xml'
SINGLE_EVENT = 'spec/lib/testData/eventbrite/single_event.xml'

describe EventbriteFeed do
  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @eventbrite = EventbriteFeed.new
  end

  describe "url building" do

    it "should contain the base url for the event brite api" do
      @eventbrite.url.should include('http://www.eventbrite.com/xml/event_search?')
    end

    it "should sort the results by date" do
      @eventbrite.url.should include('sort_by=')
      @eventbrite.url.should include('=date')
    end
    
    it "should contain the app key" do
      @eventbrite.url.should include('app_key=')
    end


  end

  describe "total pages" do

    it "should retrieve the total number of pages correctly" do
      register_page(COUNT_ONLY_PAGE)
      @eventbrite.total_pages.should eql(6)
    end

    it "should retrieve the number of pages if the total number is less than the amount showing" do
      register_page(LOW_COUNT)
      @eventbrite.total_pages.should eql(1)
    end
    
  end

  describe "grab events from xml" do
    it "should parse the correct number of pages" do
      register_page(FULL_PAGE)
      @eventbrite.grab_events_from_xml(1).length.should eql(10)
    end
  end

  describe "build address from xml" do
    it "should parse out addresses correctly" do
      correct = "23 West 10th Street, New York, United States"
      xml = read_xml_file(VENUE)
      @eventbrite.build_address(xml).should eql(correct)
    end
  end

  describe "remove formatting" do
    it "basic usage" do
      s = "Almost Famous"
      string = "<font>#{s}</font>"
      @eventbrite.remove_formatting(string).should eql(s)
      string = "<b href='anything;'><a>#{s}</a></b>"
      @eventbrite.remove_formatting(string).should eql(s)
    end
  end

  describe "map xml to item" do
    it "should properly parse out simple info" do
      event = (read_xml_file(SINGLE_EVENT)/"/event").first
      item = @eventbrite.map_xml_to_item(event)
      item.title.should eql('New York  Under 1800 Chess Tournament!')
      item.begin_at.should eql(DateTime.parse('2010-01-10 12:00:00'))
      item.end_at.should eql(DateTime.parse('2010-01-10 20:00:00'))
      item.kind.should eql("event")
      item.url.should eql('http://ccny-u1800.eventbrite.com')
      item.description.should_not be_nil
      item.should be_valid
    end

    it "should parse out the lat and long of the event" do
      event = (read_xml_file(SINGLE_EVENT)/"/event").first
      item = @eventbrite.map_xml_to_item(event)
      item.latitude.should eql(40.73)
      item.longitude.should eql(-74.0)
    end
  end
end

def register_page(page)
  FakeWeb.register_uri(:any, @eventbrite.url, :body=>IO.read(page))
end

def read_xml_file(filename)
  Nokogiri::XML(IO.read(filename))
end