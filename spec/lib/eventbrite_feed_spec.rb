require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

COUNT_ONLY_PAGE = 'spec/lib/testData/eventbrite/count.xml'
LOW_COUNT = 'spec/lib/testData/eventbrite/count_1.xml'
FULL_PAGE = 'spec/lib/testData/eventbrite/full_page.xml'

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
      @eventbrite.grab_events_from_xml(1).length
    end
  end
end

def register_page(page)
  FakeWeb.register_uri(:any, @eventbrite.url, :body=>IO.read(page))
end