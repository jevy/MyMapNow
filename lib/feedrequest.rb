require 'hpricot'
require 'open-uri'
require 'uri'

class FeedRequest
  attr_accessor :search_terms

  def initialize(args={})
    @search_terms = {:start_date=>Date.today, :end_date=>Date.today.next_week}.merge(default_terms.merge(args))
  end

  def pull_items_from_service
    result = []
    1.upto(total_pages).each do |page_number|
      events = grab_events_from_xml(page_number)
      events.each do |event|
        item = map_xml_to_item(event)
        if item.valid?
          if should_save?(item)
            result << item
          else
            return result
          end
        end
      end
    end
    return result
  end

  def open_url(url)
    open(url)
  end

  def default_terms
    {}
  end

  def total_pages
    1
  end

  def should_save?(item)
    !item.nil? and !item.begin_at.nil? and (item.begin_at <= end_date)
  end

  def remove_formatting(string)
    string = string.to_s.gsub('&amp;', '&').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&quot;', "'").gsub(/<\/?[^>]*>/,  "")
    string.sanitize.squeeze("\n").strip
  end

  def start_date
    @search_terms[:start_date]
  end

  def end_date
    @search_terms[:end_date]
  end
    
  def city
    @search_terms[:city]
  end
  
  def state
    @search_terms[:state]
  end
  
  def country
    @search_terms[:country]
  end

end

class Hash
  def to_url_params
    elements = []
    self.each_pair do |key, value|
      elements << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
    end
    elements.join('&')
  end
end

class String
  def sanitize
    self.collect{|ch| ch[0] ==194 ? ' ' : ch }.to_s
  end
end