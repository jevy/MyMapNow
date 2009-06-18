require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  
  context "find_in_bounds" do
    setup do
      @ottawa = Item.create :title => 'Ottawa', :latitude => 45.420833,
        :longitude => -75.69

      @detroit = Item.create :title => 'Detroit', :latitude => 42.3316,
        :longitude => -83.0475
    end
    
    should "include items within the bounds" do
      @items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703])
      @items.should include(@ottawa)
    end
    
    should "not include items outside of the bounds" do
      @items = Item.find_in_bounds([45.40218646,-75.7562255],[45.439658,-75.623703])
      @items.should_not include(@detroit)
    end
    
    should "include items within the bounds when bounds are strings" do
      @items = Item.find_in_bounds(['45.40218646','-75.7562255'],['45.439658','-75.623703'])
      @items.should include(@ottawa)
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
  
end