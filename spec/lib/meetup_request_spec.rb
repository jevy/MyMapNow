require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeetupRequest do
  before(:all) do
    @key =  "f2138374a26136042463e4e8e5d51"
  end

  context 'url' do
    it 'should generate the correct url for Ottawa, Ontario, Canada' do
      r = MeetupRequest.new
      r.city = 'ottawa'
      r.region = 'ontario'
      r.country = 'CA'
      r.url.should eql "http://api.meetup.com/events.xml/?city=ottawa&country=CA&key=#{@key}"
    end

    it 'should generate the correct url for Canada' do 
      r = MeetupRequest.new
      r.country = 'CA'
      r.url.should eql "http://api.meetup.com/events.xml/?country=CA&key=#{@key}"
    end

    it 'should generate the correct url for Wyoming, US' do
      r = MeetupRequest.new
      r.region = 'wyoming'
      r.country = 'US'
      r.url.should eql "http://api.meetup.com/events.xml/?country=US&key=#{@key}&state=wyoming"
    end
  end

  context 'grab_xml_events_from_page' do

    it 'should return the right number of events' do
      page = `cat spec/lib/testData/meetup/ottawa-oct-23-2009`
      FakeWeb.register_uri(:get, "http://api.meetup.com/events.xml/?city=ottawa&country=CA&key=#{@key}",
        :response => page)

      r = MeetupRequest.new
      r.city = 'ottawa'
      r.region = 'ontario'
      r.country = 'CA'

      events = r.grab_xml_events_from_page
      events.count.should eql 194
    end
  end

end
