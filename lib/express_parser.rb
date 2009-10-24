require 'hpricot'
require 'open-uri'
require 'uri'

class ExpressParser

  def initialize(document)
    @page = document
  end

  def events(page=@page)
    
  end

  def event_rows(doc=@page)
    doc_rows(doc).select{|row| is_event_row? row}
  end

  private

  def event_information(url)
     info = artist_div(Hpricot(open(url)))
     info = info[0].to_plain_text.split("\n").reject{|line| line.include?"?"}
     info.reject!{|line| line.empty?}.collect{|line| line.strip}
     return info[0], Date.parse(info[1]), info[2]
  end

  def venue_information(url)
    info = artist_div(Hpricot(open(url)))
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