require 'nokogiri'

class Meetup
  attr_reader :event_queue  # FIXME: I should be private!  Needs to be public for testing?

  @@APIKEY = "f2138374a26136042463e4e8e5d51"

  def initialize(country, city)
    @loc_city = city
    @loc_country = country
    @event_queue = Queue.new
    @loaded_page = 0
    if !location_exists?
      raise InvalidLocationException
    end
  end

  def create_events_from_until(start_date, end_date)
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
    #return if total_pages_of_feed_for_location <= @loaded_page

    @loaded_page += 1
    url = generate_geo_api_url_page(@loaded_page)
    doc = Nokogiri::XML open url

    doc.xpath('//item').each do |event|
      venue = Venue.new
      venue.name = (event/'venue_name').inner_text
      #venue.address = (event/'venue/location/street').inner_text
      venue.city = @loc_city
      venue.country = @loc_country

      #coordinates = venue.coordinates

      item_to_add = Item.new(:title => (event/'name').inner_text,
               :begin_at => Time.parse((event/'time').inner_text),
               :url => (event/'event-url').inner_text,
               :latitude => (event/'lat').inner_text,
               :longitude => (event/'lon').inner_text,
               :kind => 'event'
              )

      @event_queue << item_to_add
    end
  end

  def total_pages_of_feed_for_location
    url = generate_geo_api_url_page(1)
    begin
      doc = Nokogiri::XML open url
      Integer doc.at("//events")['totalpages'] 
    rescue
      return 0
    end
  end

  def generate_geo_api_url_page(page_number)
    "http://api.meetup.com/events.xml/?country=#{@loc_country}&city=#{@loc_city}&key=#{@@APIKEY}"
  end

  # If there is no start_time, whenever we run the script "today" at say 10am,
  # all the concerts starting tonight start at midnight (where there's no time).
  # So just push everything back one day
  def should_save?(item, start_date, end_date)
    item.begin_at >= (start_date - 1.day) && item.begin_at <= end_date
  end

  def location_exists?
    begin
      open generate_geo_api_url_page(1)
    rescue
      return false
    end

    true
  end

end

class InvalidLocationException < Exception
end
