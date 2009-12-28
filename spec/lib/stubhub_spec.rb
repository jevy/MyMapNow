require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

PAGE = `cat spec/lib/testData/stubhub/stubhub.xml`
BLANK_PAGE = `cat spec/lib/testData/stubhub/stubhub_blank.xml`
PAGE_TRIAL_1 = `cat spec/lib/testData/stubhub/stubhub_1.xml`
PAGE_NO_LENGTH = `cat spec/lib/testData/stubhub/stubhub_no_length.xml`

describe StubhubFeed do
  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @stubhub = StubhubFeed.new
  end

  describe "url" do
    
    it "should contain the base URL" do
      check = "http://www.stubhub.com/listingCatalog/select/?"
      @stubhub.url.starts_with?(check).should be_true
    end
    
    it "should contain the q element" do
      check = 'q=%252BstubhubDocumentType%253Aevent%250D%250A%252B'
      @stubhub.url.should include(check)
    end

    it "should not contain the start parameter if no page is specified" do
      check = 'start='
      @stubhub.url.should_not include(check)
    end

    it "should not contain the start parameter if a page is specified" do
      check = 'start='
      @stubhub.url(1).should_not include(check)
    end

    it "start parameter should be the page number multiplied by the number of rows" do
      @stubhub.rows = 50
      check = 'start=50'
      @stubhub.url(1).should_not include(check)
      check = 'start=100'
      @stubhub.url(3).should include(check)
    end

    it "should match this url" do
      url = "http://www.stubhub.com/listingCatalog/select/?fl=description,city,state,active,cancelled,venue_name,event_date_time_local,title,genreUrlPath,urlPath&q=%252BstubhubDocumentType%253Aevent%250D%250A%252B%2Bleaf%253A%2Btrue%250D%250A%252B%2Bdescription%253A+%22Canada%22%250D%250A%252B%2B%253Bevent_date_time_local%2Basc%250D%250A%252B%2B&rows=50"
      @stubhub.search_terms = ["Canada"]
      @stubhub.rows = 50
      @stubhub.url.should eql(url)
    end

  end

  describe "discover pages" do
    it "should return 0 if no elements are found" do
      @stubhub.rows = 50
      register_basic_page
      @stubhub.total_pages.should eql(0)
    end

    it "should return the number in the response" do
      @stubhub.rows = 50
      register_basic_page(PAGE_TRIAL_1)
      @stubhub.total_pages.should eql(2)
    end

    it "should raise a runtime exception if no response length is given" do
      @stubhub.rows = 50
      register_basic_page(PAGE_NO_LENGTH)
      lambda{@stubhub.total_pages}.should raise_error(RuntimeError)
    end
    
  end

  describe "grab xml events from page" do
    
    it "should grab 0 events from a test page" do
      register_basic_page(PAGE_NO_LENGTH)
      result = @stubhub.grab_events_from_xml(0)
      result.empty?.should be_true
    end

    it "should grab 10 events from test page" do
      register_basic_page(PAGE)
      result = @stubhub.grab_events_from_xml(0)
      result.empty?.should_not be_true
      result.length.should eql(10)
    end

  end

  describe "map xml to item" do

    before(:each) do
      register_basic_page(PAGE)
      @list = @stubhub.grab_events_from_xml(0)
    end

    it "should return a new item" do
      @stubhub.map_xml_to_item(@list.first).should be_kind_of(Item)
    end

  end

  describe "description terms" do

    it "should return nothing if no terms are selected" do
      @stubhub.description_terms.should eql("")
    end

    it "should transform single search terms correctly" do
      @stubhub.search_terms = ["Canada"]
      @stubhub.description_terms.should eql('description%3A "Canada"')
    end

    it "should transform multiple search terms correctly" do
      @stubhub.search_terms = ["The","Big", "Bang", "Theory"]
      @stubhub.description_terms.should eql('description%3A "The" "Big" "Bang" "Theory"')
    end
    
  end

end

def register_basic_page(page=BLANK_PAGE)
  FakeWeb.register_uri(:get, @stubhub.url, :body=>page)
end

