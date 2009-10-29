require 'hpricot'
require 'open-uri'
require 'uri'

class ExpressParser

  URI = 'http://www.ottawaxpress.ca'
  EXTENSION = '/music/listings.aspx'

  def initialize(date=nil)
    begin
      @page = open_uri(URI+EXTENSION+build_date_parameters(date))
    rescue OpenURI::HTTPError => error
      error_message = "Xpress Server Experienced a #{error.message}\n"
      date ||= Date.today
      raise(RuntimeError, error_message+"Cannot parse events for #{date}")
    end
  end

  def parse_events(page=@page)
    event_rows(page).collect{|row|
      info = event_information(URI+(row/"a")[0].attributes['href'])
      Item.new info
    }
  end

  def event_rows(doc=@page)
    doc_rows(doc).select{|row| is_event_row? row}
  end

  private

  def open_uri(uri)
    #User agent argument required to avoid random, 500 errors on Xpress server.
    Hpricot open(uri, 'User-Agent'=>'ruby')
  end

  def build_date_parameters(date)
    date ? "?date=#{date.strftime "%Y%m%d"}&dateC=#{date.strftime "%Y%m00"}" : ""
  end

  def event_information(url)
    info = artist_div(open_uri(url))
    location_link = doc_links(info)[0]
    info = remove_unnecessary_spacing(info[0])

    args = {:title=>info[0],:begin_at=> DateTime.parse(info[1]),
      :address=>fix_address_city(extract_address(URI+location_link.attributes['href'])),
      :url=>url,
      :description=> description(info, location_link.to_plain_text), :kind=>"Live Music"}
    args
  end

  def extract_address(url)
    venue_info = parse_event_cell(open_uri(url))
    information = remove_unnecessary_spacing(venue_info)
    information[1]
  end

  def remove_unnecessary_spacing(lines)
    lines = lines.to_plain_text.split("\n").reject{|line| line.include?"?"}
    lines = lines.reject{|line| line.strip.empty?}.collect{|line| line.strip}
    lines
  end

  def fix_address_city(address)
    address.gsub("Mtl","Montreal") unless address.nil?
  end

  def description(info, location_name)
    "#{info[0]} is putting on a show at the #{location_name}.\n#{format_extra_event_info(info)}"
  end

  def format_extra_event_info(info)
    info[3..info.length].join("\n") unless info.length <=3
  end

  def is_event_row?(row)
    has_event_links?(row) && has_event_cells?(row)
  end

  def event_links(page=@page)
    doc_links(page).select do |link|
      /iID[Salle,Groupe, Show]/.match link.attributes['href']
    end
  end

  def has_event_links?(row)
    event_links(row).length.eql?(2)
  end

  def has_event_cells?(row)
    doc_cells(row).length.eql?(8)
  end

  def doc_links(doc)
    doc/"a"
  end

  def doc_cells(doc)
    doc/"td"
  end

  def doc_rows(doc)
    doc/"tr"
  end

  def artist_div(doc)
    doc/"div[@id='pnlFiche']"
  end

  def parse_event_cell(doc)
    doc.search("span[@class='titreSpectacle']").first.parent
  end
end