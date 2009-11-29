require 'feedrequest.rb'

class MeetupRequest < FeedRequest
  attr_accessor :city, :region, :country

  @city = @region = @country = nil

  @@APIKEY = "f2138374a26136042463e4e8e5d51"

  # There is no 'region/state' for Meetup
  def url
    #URI.escape "http://api.meetup.com/events.xml/?country=#{@country}&city=#{@city}&key=#{@@APIKEY}"
    params = Hash.new
    params['city'] = @city if @city
    params['state'] = @region if @region and @country == "US"
    params['country'] = @country if @country
    params['key'] = @@APIKEY
    URI.escape "http://api.meetup.com/events.xml/?" + params.to_url_params
  end
end

class Hash
  def to_url_params
    elements = []
    keys.size.times do |i|
      elements << "#{CGI::escape(keys[i])}=#{CGI::escape(values[i])}"
    end
    elements.join('&')
  end
end

