require 'feedrequest.rb'

class LastfmRequest < FeedRequest
  attr_accessor :city, :region, :country, :start_date, :end_date

  @@APIKEY = "b819d5a155749ad083fcd19407d4fc69"

  @city = @region = @country = nil

  def pull_items_from_service
    total_pages_available = discover_total_pages
    result = []
    next_page = 1

    while(next_page <= total_pages_available)
      events_from_page = grab_xml_events_from_page(next_page)
      next_page += 1

      events_from_page.each do |event|
        item = map_xml_to_item(event)
        if (item.begin_at <= end_date)
          result << item
        else
          return result
        end
      end
    end

    return result
  end
  
  # @return all items on page as Nokogiri elements
  def grab_xml_events_from_page(page_number)
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

    item_to_add = Lastfm.new(:title => (event/'title').inner_text,
              :begin_at => LastfmRequest.extract_start_time(event),
              :end_at => LastfmRequest.generate_end_time(event),
              :url => (event/'url')[1].inner_text,
              :address => venue.full_address,
              :latitude => coordinates[0],
              :longitude => coordinates[1],
              :kind => 'event'
            )

    item_to_add
  end

  def self.extract_start_time(event)
    start_time_string = (event/'startDate').inner_text + 
      (!(event/'startTime').nil? ? " " + (event/'startTime').inner_text : "") +
      (!(event/'venue/location/timezone').nil? ? " " + (event/'venue/location/timezone').inner_text : "")
    Time.parse(start_time_string)
  end

  def self.generate_end_time(event)
    LastfmRequest.extract_start_time(event) + 3.hours
  end

  # There is no 'region/state' for Meetup
  def url(page_number)
    #URI.escape "http://api.meetup.com/events.xml/?country=#{@country}&city=#{@city}&key=#{@@APIKEY}"
    params = Hash.new
    params['location'] = location_string
    params['api_key'] = @@APIKEY
    params['page'] = page_number.to_s
    "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&" + params.to_url_params
  end

  def discover_total_pages
    begin
      xml = Nokogiri::XML open url(1)
      xml.at('events')['totalpages'].to_i
    rescue
      return 0
    end
  end

  def location_string
    result = []
    result << @city if @city
    result << @country if @country unless (@city && @state)
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
