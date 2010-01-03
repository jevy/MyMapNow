require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

COUNT_ONLY_PAGE = 'cat spec/lib/testData/eventbrite/count_only.xml'

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
      @eventbrite.url.should include('sort_by')
      @eventbrite.url.should include('=date')
    end

  end

  describe "total pages" do
#
#    it "retrieve the total number of pages correctly" do
#      register_page(COUNT_ONLY_PAGE)
#      @eventbrite.total_pages.should eql(6)
#    end
    
  end
end

def register_page(page=COUNT_ONLY_PAGE, url=nil)
  url ||= @eventbrite.url
  puts "Registering #{url} with #{page}"
  FakeWeb.register_uri(:get, url, :body=>page)
end