require 'hpricot'
require 'open-uri'
require 'uri'

class FeedRequest
  attr_accessor :start_date, :end_date, :search_terms

  def initialize(args={:start_date=>Date.today, :end_date=>Date.today.next_week})
    self.start_date = args[:start_date]
    self.end_date = args[:end_date]
    self.search_terms = args
  end

  def pull_items_from_service
    result = []
    1.upto(total_pages).each do |page_number|
      events_from_page = grab_events_from_xml(page_number)
      events_from_page.each do |event|
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
# A little hacky, deals with invalid windows(I think) characters coming out
#  of eventbrite.
  def sanitize
    self.collect{|ch| ch[0] ==194 ? ' ' : ch }.to_s
  end
end