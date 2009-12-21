require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe StubhubFeed do

  PAGE = `cat spec/lib/testData/stubhub/stubhub.xml`
  BLANK_PAGE = `cat spec/lib/testData/stubhub/stubhub_blank.xml`
  PAGE_1 = `cat spec/lib/testData/stubhub/stubhub_1.xml`
  PAGE_NO_LENGTH = `cat spec/lib/testData/stubhub/stubhub_no_length.xml`

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

    it "should contain the start parameter if a page is specified" do
      check = 'start='
      @stubhub.url(1).should include(check)
    end

    it "start parameter should be the page number multiplied by the number of rows" do
      check = 'start=10'
      @stubhub.url(1).should include(check)
      check = 'start=50'
      @stubhub.url(5).should include(check)
    end

    it "should match this url" do
      url = "http://www.stubhub.com/listingCatalog/select/?f1=description,city,state,active,cancelled,venue_name,event_time_local&q=%252BstubhubDocumentType%253Aevent%250D%250A%252B%2Bleaf%253A%2Btrue%250D%250A%252B%2Bdescription%253A%2B%22Ottawa%22%250D%250A%252B%2B&rows=10"
      url.should eql(@stubhub.url)
    end

  end

  describe "discover pages" do
    
    it "should return 0 if no elements are found" do
      register_basic_page
      @stubhub.discover_total_pages.should eql(0)
    end

    it "should return the number in the response" do
      register_basic_page(PAGE_1)
      @stubhub.discover_total_pages.should eql(78)
    end

    it "should raise a runtime exception if no response length is given" do
      register_basic_page(PAGE_NO_LENGTH)
      lambda{@stubhub.discover_total_pages}.should raise_error(RuntimeError)
    end
    
  end
  
end

def register_basic_page(page=BLANK_PAGE)
  FakeWeb.register_uri(:get, @stubhub.url, :body=>page)
end

