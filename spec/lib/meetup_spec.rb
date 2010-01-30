require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meetup do
  before(:all) do
    @key =  "f2138374a26136042463e4e8e5d51"
  end

  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end

  context 'url' do

    it 'should generate the correct url for Ottawa, Ontario, Canada' do
      r = Meetup.new(:city=>'ottawa', :state => 'ontario', :country=>'CA')
      r.url.should eql "http://api.meetup.com/events.xml/?city=ottawa&country=CA&key=#{@key}"
    end

    it 'should generate the correct url for Canada' do
      r = Meetup.new(:country=>'CA', :city=>nil, :state=>nil)
      r.url.should eql "http://api.meetup.com/events.xml/?country=CA&key=#{@key}"
    end

    it 'should generate the correct url for Wyoming, US' do
      r = Meetup.new(:state => 'wyoming', :country=>'US', :city=>nil)
      r.url.should eql "http://api.meetup.com/events.xml/?country=US&key=#{@key}&state=wyoming"
    end
  end

  context 'grab_xml_events_from_page' do

    it 'should return the right number of events' do
      page = `cat spec/lib/testData/meetup/ottawa-oct-23-2009`
      FakeWeb.register_uri(:get, "http://api.meetup.com/events.xml/?city=ottawa&country=CA&key=#{@key}",
        :response => page)

      r = Meetup.new
      r.search_terms[:city] = 'ottawa'
      r.search_terms[:state] = 'ontario'
      r.search_terms[:country] = 'CA'

      events = r.grab_events_from_xml(0)
      events.count.should eql 194
    end
  end

end

describe Meetup do
  before(:all) do
    @today = Time.mktime(2009, 10, 23 , 0, 0, 0)
  end

  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end

  it 'should return the correct items when reaching end of feed' do
    page = `cat spec/lib/testData/meetup/ottawa-oct-23-2009`
    FakeWeb.register_uri(:get, "http://api.meetup.com/events.xml/?city=ottawa&country=CA&key=f2138374a26136042463e4e8e5d51",
      :response => page)
    items = Meetup.new(:start_date => @today, :end_date => Time.gm(2009, 10, 24, 02, 0, 0),
      :city=>'ottawa', :state=>'ontario',  :country=>'CA').pull_items_from_service

    item = items.at(0)
    item.title.should eql("Halloween Meetup")
    item.begin_at.should  eql(Time.gm(2009,10,23,22,0,0))
    item.url.should eql('http://www.meetup.com/Nihongo-Ottawa/calendar/11518741/')
    item.address.should eql("7893 Bleeks Rd, Munster, ON, CA")
    item.city_wide.should be_false
    item.kind.should eql('event')

    item = items.at(1)
    item.title.should eql("CashFlow Game Night")
    item.begin_at.should eql(Time.gm(2009,10,23,22,15,0))
    item.url.should eql('http://www.meetup.com/Ottawa-Cashflow-to-Wealth-Club/calendar/11489086/')
    item.address.should eql("ottawa, CA")
    item.city_wide.should be_true
    item.kind.should eql('event')

    item = items.at(2)
    item.title.should eql("Rencontre EUROG - EUROG Gathering: Oktoberfest @ The Lindenhof")
    item.begin_at.should eql(Time.gm(2009,10,23,23,0,0))
    item.url.should eql('http://www.meetup.com/EUROG-Europeans-of-Ottawa-Gatineau/calendar/11602750/')
    item.address.should eql("268, Preston, Ottawa, ON, CA")
    item.city_wide.should be_false
    item.kind.should eql('event')

    item = items.at(3)
    item.title.should eql("ReSolutions")
    item.begin_at.should eql(Time.gm(2009, 10, 23, 23, 0, 0))
    item.end_at.should eql(Time.gm(2009, 10, 24, 02, 0, 0))
    item.url.should eql('http://www.meetup.com/htrio0/calendar/11639427/')
    item.address.should eql("ottawa, CA")
    item.city_wide.should be_true
    item.kind.should eql('event')

    #FIXME Broken Spec
    #    item = items.at(-1)
    #    item.title.should eql("Ski / Board @ Mt. Tremblant (Available: carpools, x-country skiing, snowshoeing)")
    #    item.begin_at.should eql(Time.gm(2009, 12, 19, 12, 30, 0))
    #    item.end_at.should eql(Time.gm(2009, 12, 19, 15, 30, 0))
    #    item.url.should eql('http://www.meetup.com/Singles-Outdoors-Club/calendar/11530846/')
    #    item.address.should eql("ottawa, CA")
    #    item.city_wide.should be_false
    #    item.kind.should eql('event')
  end

  it 'should return the correct items for the next week' do
    page = `cat spec/lib/testData/meetup/ottawa-oct-23-2009`
    FakeWeb.register_uri(:get, "http://api.meetup.com/events.xml/?city=ottawa&country=CA&key=f2138374a26136042463e4e8e5d51",
      :response => page)
    items = Meetup.new(:start_date=>@today, :end_date=>Time.mktime(2009,10,30,0,0,0),
      :city=>'ottawa', :state=>'ontario',  :country=>'CA').pull_items_from_service

    item = items.at(0)
    item.title.should eql("Halloween Meetup")
    item.begin_at.should  eql(Time.gm(2009,10,23,22,0,0))
    item.url.should eql('http://www.meetup.com/Nihongo-Ottawa/calendar/11518741/')
    item.address.should eql("7893 Bleeks Rd, Munster, ON, CA")
    item.kind.should eql('event')

    item = items.at(1)
    item.title.should eql("CashFlow Game Night")
    item.begin_at.should eql(Time.gm(2009,10,23,22,15,0))
    item.url.should eql('http://www.meetup.com/Ottawa-Cashflow-to-Wealth-Club/calendar/11489086/')
    item.address.should eql("ottawa, CA")
    item.kind.should eql('event')

    item = items.at(2)
    item.title.should eql("Rencontre EUROG - EUROG Gathering: Oktoberfest @ The Lindenhof")
    item.begin_at.should eql(Time.gm(2009,10,23,23,0,0))
    item.url.should eql('http://www.meetup.com/EUROG-Europeans-of-Ottawa-Gatineau/calendar/11602750/')
    item.address.should eql("268, Preston, Ottawa, ON, CA")
    item.kind.should eql('event')

    item = items.at(3)
    item.title.should eql("ReSolutions")
    item.begin_at.should eql(Time.gm(2009, 10, 23, 23, 0, 0))
    item.url.should eql('http://www.meetup.com/htrio0/calendar/11639427/')
    item.address.should eql("ottawa, CA")
    item.kind.should eql('event')

    item = items.at(-1)
    item.title.should eql("Euchre and Trivia night")
    item.begin_at.should eql(Time.gm(2009, 10, 28, 23, 15, 0))
    item.url.should eql('http://www.meetup.com/A-Memorable-Introduction-com/calendar/11641337/')
    item.address.should eql("1221 Vancouver Avenue, Ottawa, ON, CA")
    item.kind.should eql('event')
  end

end