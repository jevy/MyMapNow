require 'nokogiri'

class Lastfm
  attr_reader :event_queue  # FIXME: I should be private!  Needs to be public for testing?

  @@APIKEY = "b819d5a155749ad083fcd19407d4fc69"

  def initialize(loc)
    @loc = loc
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
    return if total_pages_of_feed_for_location <= @loaded_page

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

      item_to_add = Item.new(:title => (event/'title').inner_text,
               :begin_at => Time.parse((event/'startDate').inner_text),
               :url => (event/'url')[1].inner_text,
               :address => venue.full_address,
               :latitude => coordinates[0],
               :longitude => coordinates[1],
               :kind => 'live_music'
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
    'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=' +
      @loc + "&api_key=" + @@APIKEY + "&page=" + page_number.to_s
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
