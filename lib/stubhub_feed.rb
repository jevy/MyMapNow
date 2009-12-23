require 'feedrequest.rb'

class StubhubFeed < FeedRequest

  attr_accessor :search_terms, :rows

  URL = "http://www.stubhub.com/listingCatalog/select/?"
  COLUMNS = [%w(description city state active cancelled venue_name
event_date_time_local title genreUrlPath urlPath)].join(',')
  ROWS = 50

  def initialize
    super(start_date ||= Date.today.next_year)
    @rows ||= ROWS
  end

  def url(page_number=0)
    solr_statement =[
      escape("+stubhubDocumentType:event"),
      escape("leaf:")+"+true",
      description_terms
    ].join(solr_separator)
    solr_statement+= solr_separator
    page_number -= 1
    params = {}
    params['q'] = escape(solr_statement)
    params['fl'] = COLUMNS
    params['rows'] = ROWS
    params['start'] = params['rows'].to_i * page_number if page_number > 0 
    URL + params.to_url_params
  end

  def pull_items_from_service
    items = super unless items
    items.each do |event|
      begin
        event.geocode_address
        event.save
      rescue Graticule::AddressError
      end
    end
  end

  def grab_events_from_xml(page_number)
    xml = Nokogiri::XML open url(page_number)
    @items_left_to_process = false
    xml.search('//response//result//doc')
  end

  def map_xml_to_item(event)
    Item.new(
      :description=>(event/"[name=title]").inner_text,
      :title=> (event/"[name=description]").inner_text,
      :begin_at=> Time.parse((event/"[name=event_date_time_local]").inner_text),
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
    venue.blank? || city.blank? || state.blank? ? nil : "#{venue}, #{city}, #{state}"
  end

  def description_terms(terms=@search_terms)
    return "" unless terms
    escape("description:")+terms.collect{|term| " \"#{term}\""}.join
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
