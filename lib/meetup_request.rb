require 'feedrequest.rb'

class MeetupRequest < FeedRequest

  @@APIKEY = "f2138374a26136042463e4e8e5d51"

  @city = @region = @country = nil
  attr_accessor :city, :region, :country, :start_date, :end_date

  def initialize
    @items_left_to_process = true
  end

  def pull_items_from_service
    @event_queue = []
    result = []

    while(item = next_concert)
      result << item
    end
    result
  end

  def next_concert
    if @event_queue.empty? and @items_left_to_process
      populate_queue_with_items
    end
    @event_queue.pop
  end

  # return true if more items available
  #        false if this if this returned the last event based on criteria
  def populate_queue_with_items
    grab_xml_events_from_page.each do |event|
      item = map_xml_to_item(event)
      if should_save?(item)
        @event_queue << item
      else
        @items_left_to_process = false
        break
      end
    end
  end
  
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

  # @return all items on page as Nokogiri elements
  def grab_xml_events_from_page
    xml = Nokogiri::XML open url
    @items_left_to_process = false
    xml.xpath('//item')
    # only one page so no more items to process
  end

  def map_xml_to_item(event)
    venue = Venue.new
    venue.name = (event/'venue_name').inner_text

    public_meetup = false

    if public_meetup?(event)
      venue.address = (event/'venue_address1').inner_text
      venue.city = (event/'venue_city').inner_text
      venue.state = (event/'venue_state').inner_text
      venue.country = @country
      public_meetup = true
    else
      venue.city = @city
      venue.country = @country
      public_meetup = false
    end
      
    item_to_add = Meetup.new(:title => (event/'name').inner_text,
      :begin_at => Time.parse((event/'time').inner_text),
      :url => (event/'event_url').inner_text,
      :address => venue.full_address,
      :latitude => (event/'venue_lat').inner_text,
      :longitude => (event/'venue_lon').inner_text,
      :kind => 'event'
    )

    item_to_add.public_meetup = public_meetup
    item_to_add
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
end