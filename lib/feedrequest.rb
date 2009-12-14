class FeedRequest
  attr_accessor :city, :region, :country, :start_date, :end_date

  def initialize
    @items_left_to_process = true
  end

  def pull_items_from_service
    @event_queue = []
    result = []

    while(item = next_concert)
      result << item
    end
    result
  end

  def next_concert
    if @event_queue.empty? and @items_left_to_process
      populate_queue_with_items
    end
    @event_queue.pop
  end

  # return true if more items available
  #        false if this if this returned the last event based on criteria
  def populate_queue_with_items
    grab_xml_events_from_page.each do |event|
      item = map_xml_to_item(event)
      if should_save?(item)
        @event_queue << item
      else
        @items_left_to_process = false
        break
      end
    end
  end
end

class Hash
  def to_url_params
    elements = []
    self.each_pair do |key, value|
      elements << "#{CGI::escape(key)}=#{CGI::escape(value)}"
    end
    elements.join('&')
  end
end