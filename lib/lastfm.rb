require 'feedrequest.rb'

class Lastfm < Item

  def self.get_items(loc, start_date, end_date)
    request = LastfmRequest.new(:end_date=>end_date, :start_date=> start_date,
    :city=>loc.city, :region => loc.region, :country=>loc.country)

    items = request.pull_items_from_service
  end
end
