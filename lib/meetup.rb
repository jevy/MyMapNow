require 'xmlfeed.rb'

class Meetup < XMLFeed

  @@APIKEY = "f2138374a26136042463e4e8e5d51"

  def initialize(city, state, country)
    @loc_city = city
    if country == "canada"
      @loc_country = 'CA'
    elsif country == 'US'
      @loc_country = 'US'
    else 
      raise InvalidLocationException 
    end

    @event_queue = Queue.new
  end

  def create_events_from_until(start_date, end_date)
    raise InvalidLocationException unless location_exists?

    while(item = next_concert)
      if should_save?(item, start_date, end_date)
        item.save
      else 
        # Events ordered by start time, so the ones past this will not
        # satisfy should_save?
        break
      end
    end
  end

  def next_concert
    if @event_queue.empty? 
      populate_queue_with_items
    end

    @event_queue.pop
  end  

  # Returns number of Item's added to the queue
  def populate_queue_with_items
    url = generate_geo_api_url_page
    raw_page = open url
    doc = Nokogiri::XML raw_page

    doc.xpath('//item').each do |event|
      venue = Venue.new
      venue.name = (event/'venue_name').inner_text

      if public_meetup?(event)
        venue.address = (event/'venue_address1').inner_text
        venue.city = (event/'venue_city').inner_text
        venue.state = (event/'venue_state').inner_text
        venue.country = @loc_country
      else
        venue.city = @loc_city
        venue.country = @loc_country
      end
        
      item_to_add = Item.new(:title => (event/'name').inner_text,
               :begin_at => Time.parse((event/'time').inner_text),
               :url => (event/'event_url').inner_text,
               :address => venue.full_address,
               :latitude => (event/'venue_lat').inner_text,
               :longitude => (event/'venue_lon').inner_text,
               :kind => 'event'
              )

      @event_queue << item_to_add
    end
  end

  def public_meetup?(event)
    return (event/'venue_address1').inner_text != ''
  end

  def generate_geo_api_url_page
    URI.escape "http://api.meetup.com/events.xml/?country=#{@loc_country}&city=#{@loc_city}&key=#{@@APIKEY}"
  end

  # If there is no start_time, whenever we run the script "today" at say 10am,
  # all the concerts starting tonight start at midnight (where there's no time).
  # So just push everything back one day
  def should_save?(item, start_date, end_date)
    item.begin_at >= (start_date - 1.day) && item.begin_at <= end_date
  end

  def location_exists?
    begin
      open generate_geo_api_url_page
    rescue
      return false
    end

    true
  end

end

class InvalidLocationException < Exception
end
