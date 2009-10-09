require 'nokogiri'

class Lastfm

  @@APIKEY = "b819d5a155749ad083fcd19407d4fc69"

# def get_local_events_for(loc)
#   request_result = geo_get_events(loc)
# end

  def geo_get_events(loc)
    url = generate_geo_api_url(loc, 1)
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

  def generate_geo_api_url(loc, page_number)
    'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=' +
      loc + "&api_key=" + @@APIKEY + "&page=" + page_number.to_s
  end

end

