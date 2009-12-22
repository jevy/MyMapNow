require 'feedrequest.rb'

class StubhubFeed < FeedRequest
  URL = "http://www.stubhub.com/listingCatalog/select/?"
  COLUMNS = [%w(description city state
active cancelled venue_name event_time_local )].join(',')
  ROWS = 50
  SEARCH_TERM = "Ottawa"

  def url(page_number=0)
    #Not Pretty I know, refactorings on order.
    string =[
      escape("+stubhubDocumentType:event"),
      escape("leaf:")+"+true",
      escape("description:")+"+\"#{SEARCH_TERM}\""
    ].join(solr_separator)
    string+= solr_separator
    page_number -= 1
    params = {}
    params['q'] = escape(string)
    params['fl'] = COLUMNS
    params['rows'] = ROWS
    params['start'] = params['rows'].to_i * page_number if page_number > 0 
    #      puts URL + params.to_url_params
    URL + params.to_url_params
  end

  def grab_events_from_xml(page_number)
    xml = Nokogiri::XML open url(page_number)
    @items_left_to_process = false
    xml.search('//response//result//doc')
  end

  def map_xml_to_item(event)
    #    puts event.children
    Item.new(
      :description=>(event/"[name=description]").inner_text,
      :title=> (event/"[name=title]").inner_text,
      :begin_at=> (event/"[name=event_date_time_local]").inner_text,
      :address=> address_from_xml(event),
      :url=> build_result_url(event),
      :kind=>'event'
    )
  end

  def build_result_url(event)
    genre = (event/"[name=genreUrlPath]").inner_text
    suffix = (event/"[name=urlPath]").inner_text
    "http://stubhub.com/#{genre}/#{suffix}/"
  end

  def total_pages
    doc = Nokogiri::XML(open(url))
    attribute = doc.xpath('//response//result').attr("numFound")
    attribute ? (attribute.value.to_f/ROWS).ceil : raise("No event length")
  end

  def address_from_xml(event)
    venue = (event/"[name=venue_name]").inner_text
    city = (event/"[name=city]").inner_text
    state = (event/"[name=state]").inner_text
    "#{venue}, #{city}, #{state}"
  end

  def escape(string)
    CGI.escape(string)
  end

  def solr_separator
    escape("\r\n+ ")
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
