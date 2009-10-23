require 'hpricot'
require 'open-uri'
require 'uri'

class ExpressParser

  def initialize(url, event_type)
    @page = Hpricot open("#{url}/#{event_type}/listings.aspx")
  end

  def events(page=@page)
    events_information = event_links(page)
    events_information / 2
  end

  private 
  
  def event_links(page=@page)
    page_links(page).select do |link|
      /iID[Salle,Groupe, Show]/.match link.attributes['href']
    end
  end

  def page_links(doc=@page)
     doc/"a"
  end
end


class Array
  def chunk(number_of_chunks)
    chunks = (1..number_of_chunks).collect { [] }
    self.each_with_index do |item, index|
      chunks[index % number_of_chunks] << item
    end
    chunks
  end
  alias / chunk
end