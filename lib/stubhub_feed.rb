require 'feedrequest.rb'

class StubhubFeed < FeedRequest
  URL = "http://www.stubhub.com/listingCatalog/select/?"
  COLUMNS = [%w(description city state
active cancelled venue_name event_time_local )].join(',')
  ROWS = 50
  SEARCH_TERMS = "Ottawa"

  def url(page_number=0)
    #Not Pretty I know, refactorings on order.
    string =[
      escape("+stubhubDocumentType:event"),
      escape("leaf:")+"+true",
      escape("description:")+"+\"#{SEARCH_TERMS}\""
    ].join(escape("\r\n+ "))
    string+= escape("\r\n+ ")
    
    params = {}
    params['q'] = escape(string)
    params['f1'] = COLUMNS
    params['rows'] = 10
    params['start'] = params['rows'].to_i * page_number if page_number > 0 
#    puts URL + params.to_url_params
    URL + params.to_url_params
  end

  def grab_xml_events_from_page(page_number)
    xml = Nokogiri::XML open url(page_number)
    @items_left_to_process = false
    xml.xpath('//response//result')
  end

  def map_xml_to_item(event)
    
  end

  def discover_total_pages
    doc = Nokogiri::XML(open(url))
    attribute = doc.xpath('//response//result').attr("numFound")
    attribute ? attribute.value.to_i : raise("No event length")
  end

  def should_save?(item)
    !item.nil?
  end

  def escape(string)
    CGI.escape(string)
  end

end

class Hash
  def to_url_params(join='&')
    elements = []
    self.each_pair do |key, value|
      elements << "#{key}=#{value}"
    end
    elements.join(join)
  end
end
