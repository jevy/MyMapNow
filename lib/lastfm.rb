require 'nokogiri'

class Lastfm
  attr_reader :event_queue  # FIXME: I should be private!  Needs to be public for testing?

  @@APIKEY = "b819d5a155749ad083fcd19407d4fc69"

  def initialize(loc)
    @loc = loc
    @event_queue = Queue.new
    @loaded_page = 0
  end

  def create_events_from_until(start_date, end_date)
    while(item = next_concert)
      if (item.begin_at <= end_date) && (item.begin_at >= start_date)
        item.save
      end
    end
  end

  def next_concert
    if @event_queue.empty? 
      return false unless populate_queue_with_items != 0
    end

    @event_queue.pop
  end  

  def populate_queue_with_items
    return 0 if total_pages_of_feed_for_location < @loaded_page + 1

    @loaded_page += 1
    url = generate_geo_api_url_page(@loaded_page)
    doc = Nokogiri::XML open url

    values_added = 0
    doc.xpath('//event').each do |event|
      venue = Venue.new
      venue.name = event.at('//venue/name').inner_text
      venue.address = event.at('//venue//location/street').inner_text
      venue.city = event.at('//venue//location/city').inner_text
      venue.country = event.at('//venue//location/country').inner_text

      coordinates = venue.coordinates

      start_time_string = event.at('//startDate').inner_text

      item = Item.new(:title => event.at('//title').inner_text,
               :begin_at => Time.parse(start_time_string),
               :url => event.at('//event/url').inner_text,
               :address => venue.full_address,
               :latitude => coordinates[0],
               :longitude => coordinates[1],
               :kind => 'event'
              )

      @event_queue << item
      values_added += 1
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

  def generate_geo_api_url_page(page_number)
    'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=' +
      @loc + "&api_key=" + @@APIKEY + "&page=" + page_number.to_s
  end

end

