require 'nokogiri'

class Lastfm
  attr_reader :event_queue  # FIXME: I should be private!  Needs to be public for testing?

  @@APIKEY = "b819d5a155749ad083fcd19407d4fc69"

  def initialize(loc)
    @loc = loc
    @event_queue = Queue.new
    @loaded_page = 0
    @items_processed = 0
  end

  def create_events_from_until(start_date, end_date)
    while(item = next_concert)
      if item.begin_at >= start_date && item.begin_at <= end_date
        item.save
      end
    end
  end

  def next_concert
    if @event_queue.empty? 
      return nil if !items_left_to_queue
      populate_queue_with_items
    end

    @event_queue.pop
  end  

  # Returns number of Item's added to the queue
  def populate_queue_with_items
    values_added = 0
    return values_added if total_pages_of_feed_for_location <= @loaded_page

    @loaded_page += 1
    url = generate_geo_api_url_page(@loaded_page)
    doc = Nokogiri::XML open url

    doc.xpath('//event').each do |event|
      venue = Venue.new
      venue.name = (event/'venue/name').inner_text
      venue.address = (event/'venue/location/street').inner_text
      venue.city = (event/'venue/location/city').inner_text
      venue.country = (event/'venue/location/country').inner_text

      coordinates = venue.coordinates

      start_time_string = (event/'startDate').inner_text

      item = Item.new(:title => (event/'title').inner_text,
               :begin_at => Time.parse(start_time_string),
               :url => (event/'url').inner_text,
               :address => venue.full_address,
               :latitude => coordinates[0],
               :longitude => coordinates[1],
               :kind => 'event'
              )

      @event_queue << item
      values_added += 1
      @items_processed += 1
    end

    return values_added

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

  def total_items_in_feed
    url = generate_geo_api_url_page(1)
    begin
      doc = Nokogiri::XML open url
      Integer doc.at("//events")['total'] 
    rescue
      return 0
    end
  end

  def items_left_to_queue
    return true if total_items_in_feed > @items_processed
    return false
  end
    
  def generate_geo_api_url_page(page_number)
    'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=' +
      @loc + "&api_key=" + @@APIKEY + "&page=" + page_number.to_s
  end

end

