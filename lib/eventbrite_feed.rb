require 'feedrequest.rb'

class EventbriteFeed < FeedRequest

  API = 'NDcxMGM1MmQxMmI3'
  BASE_URL = 'http://www.eventbrite.com/xml/event_search?'
  
  def url(page_number=1)
    params = {
      'app_key' =>API,
      'country'=>'CA',
      'sort_by'=>'date',
      "page"=>page_number
    }
    BASE_URL + params.to_url_params
  end

  def total_pages
    doc = Nokogiri::XML(open(url))
    total = (doc.xpath("/events//summary/total_items")).inner_text.to_f
    rows = (doc/"/events/summary/num_showing").inner_text.to_f
    (total/rows).ceil
  end

  def grab_events_from_xml(page_number)
    xml = Nokogiri::XML(open(url(page_number)))
    (xml/'/events/event')
  end

  def pull_items_from_service
    super.each do |event|
      event.save
    end
  end

  def map_xml_to_item(event)
    coordinates = (event/"venue/Lat-Long").inner_text.split('/')
    Item.new(
      :latitude => coordinates[0].to_f,
      :longitude=> coordinates[1].to_f,
      :description=>remove_formatting((event/'description').inner_text),
      :address=>build_address(event),
      :title=>((event/'title').inner_text),
      :begin_at=>DateTime.parse((event/'start_date').first.inner_text),
      :end_at=>DateTime.parse((event/'end_date').first.inner_text),
      :url=>((event/'url').last.inner_text),
      :kind=>'event'
    )
  end

  def build_address(event)
    address = (event/"venue/address").inner_text
    city = (event/"venue/city").inner_text
    country = (event/"venue/country").inner_text
    "#{address}, #{city}, #{country}"
  end

end