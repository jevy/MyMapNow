require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'feedrequest.rb'

describe FeedRequest do
  before(:each) do
    @feed_request = FeedRequest.new
  end

  describe "initialize" do

    it "should create an item with the correct initial dates" do
      @feed_request = FeedRequest.new(Date.today.next_week, Date.today)
      @feed_request.start_date.should eql(Date.today)
      @feed_request.end_date.should eql(Date.today.next_week)
    end
    
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
      inner = build_valid_item
      @feed_request.stub!(:total_pages).and_return(1)
      @feed_request.stub!(:grab_events_from_xml).and_return([inner])
      @feed_request.stub!(:map_xml_to_item).and_return(inner)
      @feed_request.pull_items_from_service.should eql([inner])
    end

    it "should populate multiple items only valid ones" do
      result = [i1 = build_valid_item, i2 = build_valid_item, Item.new]
      
      @feed_request.stub!(:total_pages).and_return(1)
      @feed_request.stub!(:grab_events_from_xml).and_return([1, 1])
      @feed_request.stub!(:map_xml_to_item).and_return(i1, i2)
      @feed_request.pull_items_from_service.should eql([i1,i2])
    end

    it "should call grab events from xml for each page" do
      @feed_request.stub!(:total_pages).and_return(4)
      @feed_request.should_receive(:grab_events_from_xml).with(1).and_return([])
      @feed_request.should_receive(:grab_events_from_xml).with(2).and_return([])
      @feed_request.should_receive(:grab_events_from_xml).with(3).and_return([])
      @feed_request.should_receive(:grab_events_from_xml).with(4).and_return([])

      @feed_request.stub!(:map_xml_to_item).and_return(Item.new, Item.new, Item.new, Item.new)
      @feed_request.pull_items_from_service.should be_empty
    end

  end

  describe "should save" do
    it "should not save nil items" do
      @feed_request.end_date = Date.today
      @feed_request.should_save?(nil).should be_false
    end

    it "should not save items where begin_at is nil" do
      @feed_request.end_date = Date.today
      @feed_request.should_save?(Item.new).should be_false
    end

    it "should not save items where the item is invalid" do
      @feed_request.end_date = Date.today
      @feed_request.should_save?(Item.new(:begin_at=>Date.today)).should be_false
    end

    it "should save items where the item begin_at date is before the end date" do
      i = build_valid_item(Date.yesterday)
      @feed_request.end_date = Date.today
      @feed_request.should_save?(i).should be_true
    end
  end

  describe "populate queue with items" do
    
  end
end

def build_valid_item(date = Date.today)
  result = Item.new(:begin_at=>date)
  result.stub!(:valid?).and_return(true)
  result
end