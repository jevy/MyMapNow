require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  
  context "find_in_bounds" do
    setup do
      @ottawa = Item.create :title => 'Ottawa', :latitude => 45.420833,
        :longitude => -75.69, :begin_at => 3.hours.from_now
      
      @ottawa_old = Item.create :title => 'Ottawa Old', :latitude => 45.420833,
        :longitude => -75.69, :begin_at => 10.months.ago
        
      @detroit = Item.create :title => 'Detroit', :latitude => 42.3316,
        :longitude => -83.0475, :begin_at => 4.hours.from_now
    end
    
    should "include items within the bounds" do
      @items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703], 5.days.ago, 5.days.from_now)
      @items.should include(@ottawa)
    end
    
    should "not include items outside of the bounds" do
      @items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703], 5.days.ago, 5.days.from_now)
      @items.should_not include(@detroit)
    end
    
    should "include items within the bounds when bounds are strings" do
      @items = Item.find_in_bounds(['45.40218646','-75.7562255'],['45.439658','-75.623703'], 5.days.ago, 5.days.from_now)
      @items.should include(@ottawa)
    end
    
    should "limit the dates to a provided range" do
      items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703], 5.days.ago, 5.days.from_now)
      items.should_not include(@ottawa_old)
      
      old_items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703], 11.months.ago, 9.months.ago)
      old_items.should include(@ottawa_old)
    end
  end
  
  context "attach_geocode" do
    setup do
      @ottawa = Item.new :title => 'Ottawa', :address => "Ottawa, ON, Canada"
    end
    
    should "set the latitude and longitude before saving" do
      @ottawa.save
      assert_in_delta 45.420833, @ottawa.latitude, 0.001
      assert_in_delta -75.69, @ottawa.longitude, 0.001
    end
    
    should "set the latitude and longitude" do
      @ottawa.attach_geocode
      assert_in_delta 45.420833, @ottawa.latitude, 0.001
      assert_in_delta -75.69, @ottawa.longitude, 0.001
    end
  end
  
  context "body" do
    should "be empty if the description is blank" do
      Item.new.body.should be_blank
    end
  end
end