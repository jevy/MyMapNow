require 'nokogiri'

class Lastfm

  @@APIKEY = "b819d5a155749ad083fcd19407d4fc69"

  def initialize(loc)
    @loc = loc
  end

  def create_events_from_until(start_date, end_date)
    while(event = next_concert)
      if event.begin_at <= end_date && event.begin_at >= start_date
        create_concert_at_venue(event, venue) 
      end
    end
  end

  def next_concert
    if @concerts_in_current_doc.nil?
      url = generate_geo_api_url_page(loc, 1)
      return nil if url.nil?
      doc = Nokogiri::XML open url
      @concerts_in_current_doc = doc.xpath('//event')
    elseif @concerts_in_current_doc.empty?
      @current_page_number += 1
      url = generate_geo_api_url_page(loc, @current_page_number)
      return nil if url.nil?
      doc = Nokogiri::XML open url
      @concerts_in_current_doc = doc.xpath('//event')
    end

    # How do I return the event and venue?
    
  end

  def geo_get_events(loc)
    url = generate_geo_api_url_page(loc, 1)
    doc = Nokogiri::XML open url

    doc.xpath('//event').each do |event|
      venue = Venue.new
      venue.name = event.at('//venue/name').inner_text
      venue.address = event.at('//venue//location/street').inner_text
      venue.city = event.at('//venue//location/city').inner_text
      venue.country = event.at('//venue//location/country').inner_text

      coordinates = venue.coordinates

      start_time_string = event.at('//startDate').inner_text

      Item.create(:title => event.at('//title').inner_text,
                  :begin_at => Time.parse(start_time_string),
                  :url => event.at('//event/url').inner_text,
                  :address => venue.full_address,
                  :latitude => coordinates[0],
                  :longitude => coordinates[1],
                  :kind => 'event'
                 )
    end
  end

  def total_pages_of_feed_for_location
    url = generate_geo_api_url_page(1)
    begin
      doc = Nokogiri::XML open url
      Integer doc.at("//events")['totalpages'] 
    rescue
      return nil
    end
  end

  def generate_geo_api_url_page(page_number)
    'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=' +
      @loc + "&api_key=" + @@APIKEY + "&page=" + page_number.to_s
  end

end

