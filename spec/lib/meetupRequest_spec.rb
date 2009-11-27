require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeetupRequest do

  context 'url_generator' do
    before(:all) do
      @key =  "f2138374a26136042463e4e8e5d51"
    end

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

end
