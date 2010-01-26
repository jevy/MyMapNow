require 'feedrequest.rb'

class Meetup < FeedRequest

  @search_terms={:city => 'ottawa',
    :state => 'ontario', :country => 'CA'}

  URL ="http://api.meetup.com/events.xml/?"
  API_KEY = "f2138374a26136042463e4e8e5d51"
  
  def url
    params = {}
    params['city'] =  city if city
    params['state'] = state if state and country == "US"
    params['country'] = country if country
    params['key'] = API_KEY
    URI.escape(URL + params.to_url_params)
  end

  # @return all items on page as Nokogiri elements
  def grab_events_from_xml(page_number=nil)
    xml = Nokogiri::XML(open(url))
    xml.xpath('//item')
    # only one page so no more items to process
  end

  def map_xml_to_item(event)
    info ={}
    if public_meetup?(event)
      info[:address] = (event/'venue_address1').inner_text
      info[:city] = (event/'venue_city').inner_text
      info[:state] = (event/'venue_state').inner_text
    else
      info[:city] = city
    end
    info[:country] = country
      
    Item.new(:title => (event/'name').inner_text,
      :begin_at => extract_start_time(event),
      :end_at => extract_end_time(event),
      :url => (event/'event_url').inner_text,
      :address => address(info[:address], info[:city], info[:state], info[:country]),
      :latitude => (event/'venue_lat').inner_text,
      :longitude => (event/'venue_lon').inner_text,
      :kind => 'event',
      :city_wide=> !public_meetup?(event)
    )
  end

  def extract_start_time(event)
    Time.parse((event/'time').inner_text)
  end

  def extract_end_time(event)
    Time.parse((event/'time').inner_text) + 3.hours
  end

  def public_meetup?(event)
    return (event/'venue_address1').inner_text != ''
  end

  # If there is no start_time, whenever we run the script "today" at say 10am,
  # all the concerts starting tonight start at midnight (where there's no time).
  # So just push everything back one day
  def should_save?(item)
    item.begin_at >= (start_date - 1.day) && item.begin_at <= end_date
  end

  def address(address, city, state, country)
    result = []
    result << address  unless address.nil? or address.empty?
    result << city     unless city.nil? or city.empty?
    result << state    unless state.nil? or state.empty?
    result << country  unless country.nil? or country.empty?
    result.join(", ")
  end
end
