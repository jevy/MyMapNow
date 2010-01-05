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
    xml.search('//events//event')
  end


  def map_xml_to_item(event)
    Item.new(
    )
  end

end