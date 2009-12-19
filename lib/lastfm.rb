require 'feedrequest.rb'

class Lastfm < Item

  def self.get_items(loc, start_date, end_date)
    request = LastfmRequest.new
    request.city = loc.city
    request.region = loc.region
    request.country = loc.country
    request.start_date = start_date
    request.end_date = end_date

    items = request.pull_items_from_service
  end
end
