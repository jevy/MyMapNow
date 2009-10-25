require 'hpricot'
require 'open-uri'
require 'uri'

class ExpressParser

  def initialize(document, base_uri)
    @page = document
    @uri = base_uri
  end

  def parse_events(page=@page)
    event_rows(page).collect{|row|
      info = event_information(@uri+(row/"a")[0].attributes['href'])
      Item.new info
    }
  end

  def event_rows(doc=@page)
    doc_rows(doc).select{|row| is_event_row? row}
  end

  private

  def event_information(url)
    info = artist_div(Hpricot open(url, 'User-Agent'=>'ruby'))
    location_name = doc_links(info).text
    info = info[0].to_plain_text.split("\n").reject{|line| line.include?"?"}
    info.reject!{|line| line.strip.empty?}
    info.collect!{|line| line.strip}

    {:title=>info[0],:begin_at=> DateTime.parse(info[1]),
      :address=>info[2], :url=>url,
      :description=> description(info, location_name),:kind=>"Live Music"
    }
  end

  def description(info, location_name)
    "#{info[0]} is putting on a show at the #{location_name}.\n#{format_extra_event_info(info)}"
  end


  def format_extra_event_info(info)
    info[3..info.length].join('\n') unless info.length <=3
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
end