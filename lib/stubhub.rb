require 'feedrequest.rb'

class Stubhub < FeedRequest

  URL = "http://www.stubhub.com/listingCatalog/select/?"
  COLUMNS = [%w(description city state active cancelled venue_name
event_date_time_local title genreUrlPath urlPath venue_config_id)].join(',')

  def default_terms
    {:rows => 50,
    :list => ["Canada", "Ottawa", "Toronto", "Ontario", "Montreal"],
    :end_date=> (Date.today + 6.months)
    }
  end

  def url(page_number=0)
    solr_statement =[
      escape("+stubhubDocumentType:event"),
      escape("leaf:")+"+true",
      description_terms,
      escape(";event_date_time_local asc")
    ].join(solr_separator)
    solr_statement+= solr_separator
    page_number -= 1
    params = {}
    params['q'] = escape(solr_statement)
    params['fl'] = COLUMNS
    params['rows'] = rows
    params['start'] = params['rows'].to_i * page_number if page_number > 0
    URL + params.to_url_params
  end

  def pull_items_from_service
    super.each do |event|
      begin
        event.geocode_address
        event.save
      rescue Graticule::AddressError
      end
    end
  end

  def grab_events_from_xml(page_number)
    xml = Nokogiri::XML(open(url(page_number)))
    xml.search('/response/result/doc')
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

  def rows
    @search_terms[:rows] ||= 50
  end

  def build_result_url(event)
    genre = (event/"[name=genreUrlPath]").inner_text
    suffix = (event/"[name=urlPath]").inner_text
    "http://stubhub.com/#{genre}/#{suffix}/"
  end

  def total_pages
    doc = Nokogiri::XML(open(url))
    attribute = doc.xpath('//response//result').attr("numFound")
    attribute ? (attribute.value.to_f/rows).ceil : raise("No event length")
  end

  def address_from_xml(event)
    venue_id = (event/"[name=venue_config_id]").inner_text
    venue = (event/"[name=venue_name]").inner_text unless venue = retrieve_address(venue_id)
    city = (event/"[name=city]").inner_text
    state = (event/"[name=state]").inner_text
    venue.blank? || city.blank? || state.blank? ? nil : "#{venue}, #{city}, #{state}"
  end

  def description_terms(terms=@search_terms[:list])
    return "" unless terms && !terms.empty?
    escape("description:") + terms.collect{|term| " \"#{term}\""}.join("")
  end

  def escape(string)
    CGI.escape(string)
  end

  def solr_separator
    escape("\r\n+ ")
  end

  def retrieve_address(venue_id)
    string = URL+"q=stubhubDocumentType:venue+venue_config_id:#{venue_id}&rows=1"
    results = (Nokogiri::XML(open(string))/"response/result/doc")
    results.length > 0 ? (results.first/"[name=addr1]").inner_text : nil
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
