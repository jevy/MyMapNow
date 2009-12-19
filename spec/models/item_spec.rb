require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @valid_attributes = {
      :title => "Prime Minister's Residence",
      :begin_at => Time.mktime(1983, 3, 22, 15, 35, 0),
      :latitude => 45.444363,
      :longitude => -75.693811,
      :address => '24 Sussex Dr., Ottawa, ON, Canada'
    }
    
    Geocoder.stub!(:locate => stub(:latitude => 0, :longitude => 0))
  end

  it "should create a new instance given valid attributes" do
    Item.create(@valid_attributes).should be_valid
  end

  it "should require a title" do
    item = Item.create(@valid_attributes.merge(:title => nil))
    item.should_not be_valid
    item.should have(1).error_on(:title)
  end

  it "should require a start time" do
    item = Item.create(@valid_attributes.merge(:begin_at => nil))
    item.should_not be_valid
    item.should have(1).error_on(:begin_at)
  end

  it "should require a latitude and longitude, or an address" do
    item = Item.create(@valid_attributes.merge(:latitude => nil, :longitude => nil, :address => nil))
    item.should_not be_valid
    item.should have(1).error_on(:latitude)
    item.should have(1).error_on(:longitude)
    item.should have(1).error_on(:address)
  end

  it "should not require lat/lng if an address is provided" do
    item = Item.create(@valid_attributes.merge(:latitude => nil, :longitude => nil))
    item.should be_valid
  end

  it "should not require an address if if lat/lng are provided" do
    item = Item.create(@valid_attributes.merge(:address => nil))
    item.should be_valid
  end

  it "should require end time to be after the beginning time" do
    item = Item.create(@valid_attributes.merge(:begin_at => 5.months.ago, :end_at => 10.months.ago))
    item.should_not be_valid
    item.should have(1).error_on(:end_at)
  end
end
#
#describe "tagging" do
#  before(:each) do
#    @valid_attributes = {
#      :title => "Prime Minister's Residence",
#      :begin_at => Time.mktime(1983, 3, 22, 15, 35, 0),
#      :latitude => 45.444363,
#      :longitude => -75.693811,
#      :address => '24 Sussex Dr., Ottawa, ON, Canada'
#    }
#
#    @item1 = Item.create(@valid_attributes)
#    @item1.tag_list = "foo, bar"
#    @item1.save
#
#    @item2 = Item.create(@valid_attributes)
#    @item2.tag_list = "bar, baz"
#    @item2.save
#  end
#
#  it "should find multiple items with a tag" do
#    Item.tagged_with('bar', :on => :tags).length.should == 2
#    Item.tagged_with('bar', :on => :tags).should include(@item1)
#    Item.tagged_with('bar', :on => :tags).should include(@item2)
#  end
#
#  it "should find one item, but not the other using tags" do
#    Item.tagged_with('foo', :on => :tags).should include(@item1)
#    Item.tagged_with('foo', :on => :tags).should_not include(@item2)
#  end
#
#  it "should find all items with intersecting tags" do
#    Item.tagged_with('foo, baz', :on => :tags).length.should == 2
#    Item.tagged_with('foo, baz', :on => :tags).should include(@item1)
#    Item.tagged_with('foo, baz', :on => :tags).should include(@item2)
#  end
#end

describe "Bounded item finding" do
  before(:each) do
    @detroit = Item.create(:title => 'Detroit',
      :latitude => 42.3316, :longitude => -83.0475,
      :begin_at => Time.mktime(2009, 10, 15))

    @ottawa_events = {
      'economic_showcase' => Item.create(:title => 'Eastern Ottawa Economic Showcase',
        :latitude => 45.397936, :longitude => -75.685518,
        :begin_at => Date.new(2009, 10, 12)),
      'schmoozefest' => Item.create(:title => 'Schmoozefest',
        :latitude => 45.395674, :longitude => -75.70637,
        :begin_at => Date.new(2009, 10, 19)),
      'charity_gala' => Item.create(:title => 'Old Hollywood Charity Gala',
        :latitude => 45.430312, :longitude => -75.698386,
        :begin_at => Date.new(2009, 10, 16)),
      'beatles_tribute' => Item.create(:title => 'Beatles Tribute 1964',
        :latitude => 45.423494, :longitude => -75.697933,
        :begin_at => Date.new(2009, 10, 15)),
      'oktoberfest' => Item.create(:title => 'Oktoberfest',
        :latitude => 45.342283, :longitude => -75.709856,
        :begin_at => Date.new(2009, 10, 17)),
      'big_art' => Item.create(:title => 'Big Art in the City',
        :latitude => 45.418365, :longitude => -75.704319,
        :begin_at => Date.new(2009, 10, 18)),
      'chorus_line' => Item.create(:title => 'A Chorus Line - Broadway Musical',
        :latitude => 45.423422, :longitude => -75.694797,
        :begin_at => Date.new(2009, 10, 19)),
      'mackenzie_king' => Item.create(:title => 'Hike the Mackenzie King Estate',
        :latitude => 45.487354, :longitude => -75.842725,
        :begin_at => Date.new(2009, 10, 10)),
      'halloween_party' => Item.create(:title => 'The Great Ottawa Halloween Party',
        :latitude => 45.423422, :longitude => -75.694797,
        :begin_at => Date.new(2009, 10, 30)),
      'cultural_showcase' => Item.create(:title => 'Cultural Showcase',
        :latitude => 45.380063, :longitude => -75.693435,
        :begin_at => Date.new(2009, 10, 16),
        :end_at => Date.new(2009, 10, 17)),
      'animation_fest' => Item.create(:title => 'Ottawa International Animation Festival',
        :latitude => 45.429355, :longitude => -75.684632,
        :begin_at => Date.new(2009, 10, 12),
        :end_at => Date.new(2009, 10, 16)),
      'blues_fest' => Item.create(:title => 'Ottawa Blues Festival',
        :latitude => 45.430312, :longitude => -75.698386,
        :begin_at => Date.new(2009, 10, 29),
        :end_at => Date.new(2009, 11, 1)),
      'folk_fest' => Item.create(:title => 'CKCU Ottawa Folk Festival',
        :latitude => 45.399761, :longitude => -75.731893,
        :begin_at => Date.new(2009, 10, 16),
        :end_at => Date.new(2009, 10, 17))
    }
  end

  it "should find every event in ottawa when searching all of October" do
    items = Item.find_in_bounds([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-75.437867755127],
      Time.mktime(2009, 10, 1), Time.mktime(2009, 11, 1))
    items.length.should == @ottawa_events.size
  end

  it "should not find anything between the 20th and 28th" do
    items = Item.find_in_bounds([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-75.437867755127],
      Time.mktime(2009, 10, 20), Time.mktime(2009, 10, 28))
    items.length.should == 0
  end

  it "should find items that started before the bounds, but end inside the time bounds" do
    items = Item.find_in_bounds([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-75.437867755127],
      Time.mktime(2009, 10, 17), Time.mktime(2009, 11, 1))
    items.should include(@ottawa_events['cultural_showcase'])
    items.should include(@ottawa_events['folk_fest'])
  end

  it "should find items that both start and end outside the bounds" do
    items = Item.find_in_bounds([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-75.437867755127],
      Time.mktime(2009, 10, 13), Time.mktime(2009, 10, 14))
    items.should include(@ottawa_events['animation_fest'])
    items.should_not include(@ottawa_events['economic_showcase'])
    items.should_not include(@ottawa_events['beatles_tribute'])
  end

  it "should not find detroit in the same bounds" do
    items = Item.find_in_bounds([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-75.437867755127],
      Time.mktime(2009, 10, 1), Time.mktime(2009, 11, 1))
    items.should_not include(@detroit)
  end
end

describe "Item Geocoding" do
  before(:each) do
    @valid_attributes = {
      :title => "Prime Minister's Residence",
      :begin_at => Time.mktime(1983, 3, 22, 15, 35, 0),
      :latitude => 45.444363,
      :longitude => -75.693811,
      :address => '24 Sussex Dr., Ottawa, ON, Canada'
    }
  end

  it "should geocode an address if provided" do
    geocoder = stub(:latitude => @valid_attributes[:latitude], :longitude => @valid_attributes[:longitude])
    Geocoder.should_receive(:locate).with(@valid_attributes[:address]).and_return(geocoder)
    item = Item.create(@valid_attributes.merge(:latitude => nil, :longitude => nil))
    item.latitude.should == @valid_attributes[:latitude]
    item.longitude.should == @valid_attributes[:longitude]
  end

  it "should not geocode if latitude and longitude are provided" do
    Geocoder.should_not_receive(:locate)
    item = Item.create(@valid_attributes)
  end
end

describe "Relationships" do

  before(:each) do
    @user = User.new(:email=>'user@test.ca', :password=>'test1',
      :password_confirmation=>'test1', :name=>'test')
    @item = Item.new(:user=>@user, :title=>'test_item',
      :begin_at=>Time.now, :address=>'6307 Centre Street SW, Calgary Alberta',
      :latitude=>50.9952449, :longitude=>-114.0638135)
    @item2 = Item.new(:user=>@user, :title=>'cant match first item',
      :begin_at=>Time.now, :address=>'425 5 Street SW, Calgary Alberta',
      :latitude=>51.0493941, :longitude=>-114.0735727)
  end

  it "should be able to be associated with an item" do
    @user.save; @item.save
    results = Item.find_all_by_user_id(@user.id)
    results.should have_exactly(1).items
    results.should include(@item)
  end

  it "should be able to have multiple items be associated with it" do
    @user.save; @item.save; @item2.save    
    results = Item.find_all_by_user_id(@user.id)
    results.should have_exactly(2).items
    results.should include(@item, @item2)
  end

  after(:each) do
    @user.destroy if defined?(@user)
    @item.destroy if defined?(@item)
    @item2.destroy if defined?(@item2)
  end
end

describe "Duplicate event checking" do
  before(:each) do
    @item_params = {
      :title => "Grey Cup 2009",
      :begin_at => Time.now,
      :latitude => 51.071504,
      :longitude => -114.122307,
      :address => 'McMahon Stadium, Calgary, Alberta'
    }
    Item.create(@item_params).should be_valid
  end

  it "should not allow two items with exactly the same name to be valid same case" do
    Item.new(@item_params).should_not be_valid
  end

  it "should not allow two items with exactly the same name to be valid, different cases first letter" do
    @item_params[:title] = "grey Cup 2009"
    Item.new(@item_params).should_not be_valid
  end

  it "should not allow two items with exactly the same name to be valid, different cases middle letter" do
    @item_params[:title] = "Grey cup 2009"
    Item.new(@item_params).should_not be_valid
  end

  it "should not allow two items with exactly the same name to be valid, opposite cases" do
    @item_params[:title] = "gREY cUP 2009"
    Item.new(@item_params).should_not be_valid
  end

  it "should not allow the same string w/o spaces to be saved twice" do
    @item_params[:title].gsub(' ', '')
    Item.new(@item_params).should_not be_valid
  end

  it "should allow 2 characters to be different" do
    @item_params.merge!(:title=>'Brey Lup 2009')
    Item.new(@item_params).should_not be_valid    
  end

  it "should validate the same event(title) 1 week apart " do
    @item_params.merge!(:begin_at=>Time.now.advance(:weeks=>1))
    Item.new(@item_params).should be_valid
  end

  describe "date/time boundary checking" do
    it "should not validate an event 1:59 hours before another event with the same name" do
      @item_params.merge!(:begin_at=>@item_params[:begin_at].advance(:hours=>-2,:minutes=>1))
      Item.new(@item_params).should_not be_valid
    end

    it "should not validate an event 2 hours before another event with the same name" do
      @item_params.merge!(:begin_at=>@item_params[:begin_at].advance(:hours=>-2))
      Item.new(@item_params).should_not be_valid
    end

    it "should validate an event 2:01 hours before another event with the same name" do
      @item_params.merge!(:begin_at=>@item_params[:begin_at].advance(:hours=>-2, :minutes=>-1))
      Item.new(@item_params).should be_valid
    end

    it "should not validate an event 1:59 hours after another event with the same name" do
      @item_params.merge!(:begin_at=>@item_params[:begin_at].advance(:hours=>2,:minutes=>-1))
      Item.new(@item_params).should_not be_valid
    end
  
    it "should not validate an event 2 hours after another event with the same name" do
      @item_params.merge!(:begin_at=>@item_params[:begin_at].advance(:hours=>2))
      Item.new(@item_params).should_not be_valid
    end

    it "should validate an event 2:01 hours after another event with the same name" do
      @item_params.merge!(:begin_at=>@item_params[:begin_at].advance(:hours=>2, :minutes=>1))
      Item.new(@item_params).should be_valid
    end
  end
end

describe "Item Hash by Date" do

  before(:each) do
    @item_params = {
      :title => "Grey Cup 2009",
      :begin_at => Date.today,
      :latitude => 45.397936, :longitude => -75.685518,
      :address => 'McMahon Stadium, Calgary'
    }
    @second_item_params = {
      :title => "Zombie Apocalypse",
      :begin_at => Date.tomorrow,
      :latitude => 45.397936, :longitude => -75.685518,
      :address => 'McMahon Stadium, Calgary'
    }
    @start_time = Date.yesterday
    @end_time = Date.tomorrow.tomorrow

    @first_item = Item.create(@item_params)
    @second_item = Item.create(@second_item_params)
  end

  it "should return items in correct format" do
    result = Item.group_in_bounds_by_date([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-74.437867755127],
      Date.today.beginning_of_month, Date.today.end_of_month)
    result.should be_kind_of(Hash)
    result.should_not be_nil
    result.keys.should have_at_least(2).items
    result.values.flatten.should have_at_least(2).items
    key = result.keys[0]
    key.should eql(@second_item.begin_at.to_date)
  end

  it "should return items keyed by their date" do
    result = Item.group_in_bounds_by_date([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-74.437867755127],
      Date.today.beginning_of_month, Date.today.end_of_month)
    result.should be_kind_of(Hash)
    key_date = result.keys[0]
    key_date.should eql(@second_item.begin_at.to_date)
  end

  it "should return multiple items by their respective date" do
    result = Item.group_in_bounds_by_date([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-74.437867755127],
      Date.today.beginning_of_month, Date.today.end_of_month)
    result.should_not be_nil
    result.each_pair do |key, values|
      values.each{|item| item.begin_at.to_date.should eql(key) }
    end
  end

  it "should order keys by date" do
        result = Item.group_in_bounds_by_date([45.18458891027006,-76.02838289184575],
      [45.52139421172966,-74.437867755127],
      Date.today.beginning_of_month, Date.today.end_of_month)
  end
  
end