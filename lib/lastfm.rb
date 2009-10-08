require 'nokogiri'

class Lastfm

  @@APIKEY = "b819d5a155749ad083fcd19407d4fc69"

  def get_local_events_for(loc)
    request_result = geo_get_events(loc)
  end

  def geo_get_events(loc)
    url = generate_geo_api_url(loc, page_number)
    doc = Nokogiri::HTML(open(url))
    # ...
  end

  def generate_geo_api_url(method, loc, page_number)
    'http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=' +
      loc + "&api_key=" + @@APIKEY + "&page=" + page_number.to_s
  end

  end

