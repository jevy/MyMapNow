
class Meetup < Item
  attr_accessor :public_meetup

  def self.get_items(loc, start_date, end_date)
    request = MeetupRequest.new(:start_date=>start_date, :end_date=>end_date,
    :city=>loc.city, :region=>loc.region, :country=>loc.country)
    items = request.pull_items_from_service
  end

end
