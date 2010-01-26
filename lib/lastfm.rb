require 'feedrequest.rb'

class Lastfm < FeedRequest
  URL = "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&"
  API_KEY = "b819d5a155749ad083fcd19407d4fc69"
  @search_terms = [:state => 'ontario', :country=>'canada']
  

  def grab_events_from_xml(page_number)
    xml = Nokogiri::XML open url(page_number)
    xml.xpath('//event')
  end

  # If no time specified, it will occur at midnight (earlier in the day)
  # Could be bad
  def map_xml_to_item(event)
    venue = Venue.new
    venue.name = (event/'venue/name').inner_text
    venue.address = (event/'venue/location/street').inner_text
    venue.city = (event/'venue/location/city').inner_text
    venue.country = (event/'venue/location/country').inner_text

    coordinates = venue.coordinates

    Item.new(:title => (event/'title').inner_text,
      :begin_at => extract_start_time(event),
      :end_at => generate_end_time(event),
      :url => (event/'url')[1].inner_text,
      :address => venue.full_address,
      :latitude => coordinates[0],
      :longitude => coordinates[1],
      :kind => 'event'
    )
  end

  def extract_start_time(event)
    start_time_string = (event/'startDate').inner_text + 
      (!(event/'startTime').nil? ? " " + (event/'startTime').inner_text : "") +
      (!(event/'venue/location/timezone').nil? ? " " + (event/'venue/location/timezone').inner_text : "")
    Time.parse(start_time_string)
  end

  def generate_end_time(event)
    extract_start_time(event) + 3.hours
  end

  def url(page_number=1)
    params = {}
    params['location'] = location_string
    params['api_key'] = API_KEY
    params['page'] = page_number.to_s
    URL + params.to_url_params
  end

  def total_pages
    xml = Nokogiri::XML open(url(1))
    xml.at('events')['totalpages'].to_i
  end

  def location_string
    result = []
    result <<  city if city
    result <<  country if country unless (city and state)
    result.join(',')
  end

end

class Hash
  def to_url_params
    elements = []
    keys.size.times do |i|
      elements << "#{keys[i]}=#{values[i]}"
    end
    elements.join('&')
  end
end
