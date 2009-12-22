require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'feedrequest.rb'

describe FeedRequest do
  before(:each) do
    @feed_request = FeedRequest.new
  end

  describe "pull items from service" do

    it "should not populate any items if no results from xml" do
      @feed_request.stub!(:total_pages).and_return(1)
      @feed_request.stub!(:grab_events_from_xml).and_return([])
      @feed_request.pull_items_from_service.should be_blank
    end

    it "should populate zero items with invalid item" do
      inner = Item.new
      result = [inner]
      @feed_request.stub!(:total_pages).and_return(1)
      @feed_request.stub!(:grab_events_from_xml).and_return(result)
      @feed_request.stub!(:map_xml_to_item).and_return(inner)
      
      @feed_request.pull_items_from_service.should be_blank
    end

    it "should populate a single item if it is valid" do
      inner = Item.new
      inner.stub!(:valid?).and_return(true)
      inner.begin_at = Date.today
      @feed_request.stub!(:total_pages).and_return(1)
      @feed_request.stub!(:grab_events_from_xml).and_return([inner])
      @feed_request.stub!(:map_xml_to_item).and_return(inner)
      @feed_request.pull_items_from_service.should eql([inner])
    end

  end

  describe "populate queue with items" do
    
  end
end