require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meetup do
  before(:all) do
    @today = Time.mktime(2009, 10, 23 , 0, 0, 0)
  end

  it "should parse the XML into expected values" do
   page = `cat spec/lib/testData/meetup/ottawa-oct-23-2009`
   FakeWeb.allow_net_connect = false
   FakeWeb.register_uri(:get, 'http://api.meetup.com/events.xml/?country=CA&city=ottawa&key=f2138374a26136042463e4e8e5d51', 
                        :response => page)
    meetup = Meetup.new('CA', 'ottawa')
    meetup.populate_queue_with_items
    queue = meetup.event_queue

    item = queue.pop
    item.title.should eql("Halloween Meetup")
    item.begin_at.should eql(Time.mktime(2009, 10, 23, 18, 0,0))
    item.url.should eql('http://www.meetup.com/Nihongo-Ottawa/calendar/11518741/')
    item.address.should eql("7893 Bleeks Rd, Munster, ON, CA")
    item.latitude.should eql(45.161424)
    item.longitude.should eql(-75.945004)
    item.kind.should eql('meetup')

    item = queue.pop
    item.title.should eql("CashFlow Game Night")
    item.begin_at.should eql(Time.mktime(2009, 10, 23, 18, 15,0))
    item.url.should eql('http://www.meetup.com/Ottawa-Cashflow-to-Wealth-Club/calendar/11489086/')
    item.address.should eql("ottawa, CA")
    item.latitude.should be_nil 
    item.longitude.should be_nil
    item.kind.should eql('meetup')

    item = queue.pop
    item.title.should eql("Rencontre EUROG - EUROG Gathering: Oktoberfest @ The Lindenhof")
    item.begin_at.should eql(Time.mktime(2009, 10, 23, 19, 0, 0))
    item.url.should eql('http://www.meetup.com/EUROG-Europeans-of-Ottawa-Gatineau/calendar/11602750/')
    item.address.should eql("268, Preston, Ottawa, ON, CA")
    item.latitude.should eql(45.404263)
    item.longitude.should eql(-75.711739)
    item.kind.should eql('meetup')

    item = queue.pop
    item.title.should eql("ReSolutions")
    item.begin_at.should eql(Time.mktime(2009, 10, 23, 19, 0, 0))
    item.url.should eql('http://www.meetup.com/htrio0/calendar/11639427/')
    item.address.should eql("ottawa, CA")
    item.latitude.should be_nil
    item.longitude.should be_nil
    item.kind.should eql('meetup')
  end

  it 'should generate the correct url for a Canadian location' do
    meetup = Meetup.new('CA', 'ottawa')
    meetup.generate_geo_api_url_page.should eql('http://api.meetup.com/events.xml/?country=CA&city=ottawa&key=f2138374a26136042463e4e8e5d51')

    meetup = Meetup.new('CA', 'toronto')
    meetup.generate_geo_api_url_page.should eql('http://api.meetup.com/events.xml/?country=CA&city=toronto&key=f2138374a26136042463e4e8e5d51')
  end

  it "should throw exception when the location doesn't exist" do
    page = `cat spec/lib/testData/meetup/blahblah`
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, "http://api.meetup.com/events.xml/?key=f2138374a26136042463e4e8e5d51&country=CA&city=blahblah", 
                        :response => page)
    meetup = Meetup.new('CA', 'blahblah')
    meetup.location_exists?.should be_false

    page = `cat spec/lib/testData/meetup/ottawa-oct-23-2009`
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, 'http://api.meetup.com/events.xml/?country=CA&city=ottawa&key=f2138374a26136042463e4e8e5d51', 
                        :response => page)
    meetup = Meetup.new('CA', 'ottawa')
    meetup.location_exists?.should be_true
   
  end

  it 'should create the right number of concerts for one day' do
    meetup = Meetup.new('CA', 'ottawa')
    item1 = Item.new( :title => "First meetup",
                      :begin_at => Time.mktime(2009, 10, 23, 6, 0, 0)
                    )
    item2 = Item.new( :title => "Second meetup",
                      :begin_at => Time.mktime(2009, 10, 23, 23, 59, 59)
                    )
    item3 = Item.new( :title => "Third meetup",
                      :begin_at => Time.mktime(2009, 10, 24, 0, 0, 1)
                    )
    Item.stub!(:new).and_return(item1, item2, item3)

    item1.should_receive(:save).once
    item2.should_receive(:save).once
    item3.should_not_receive(:save)
    meetup.create_events_from_until(@today, @today + 1.day)
  end

  it "should create the right number of meetups for this week" do
    meetup = Meetup.new('CA', 'ottawa')
    item1 = Item.new( :title => "First meetup",
                      :begin_at => Time.mktime(2009, 10, 23, 1, 0, 0)
                    )
    item2 = Item.new( :title => "Second meetup",
                      :begin_at => Time.mktime(2009, 10, 29, 0, 0, 0)
                    )
    item3 = Item.new( :title => "Third meetup",
                      :begin_at => Time.mktime(2009, 10, 31, 0, 0, 1)
                    )
    Item.stub!(:new).and_return(item1, item2, item3)

    item1.should_receive(:save).once
    item2.should_receive(:save).once
    item3.should_not_receive(:save)
    meetup.create_events_from_until(@today, @today + 7.days)
  end

  it "should save an item that begins after the start_date but before the end_date" do
    test_item = Item.new(:title => "Some Meetup",
                         :begin_at => Time.mktime(2009, 10, 23, 20, 0, 0)
                        )

    meetup = Meetup.new('CA', 'ottawa')
    meetup.should_save?(test_item, @today, @today + 1.day).should be_true
  end

  it "should not save an item that is outside the specified dates" do
    test_item = Item.new(:title => "Some Meetup",
                         :begin_at => Time.mktime(2009, 10, 24, 0, 0, 1)
                        )

    meetup = Meetup.new('CA', 'ottawa')
    meetup.should_save?(test_item, @today, @today + 1.day).should be_false
  end

end

