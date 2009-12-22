class FeedRequest
  attr_accessor :start_date, :end_date
  @items_left_to_process = true

  def initialize(date_end=Date.today.next_week, start=Date.today)
    self.start_date = start
    self.end_date = date_end
  end

  def pull_items_from_service
    result = []
    1.upto(total_pages).each do |page_number|
      events_from_page = grab_events_from_xml(page_number)

      events_from_page.each do |event|
        item = map_xml_to_item(event)
        if item.valid?
          if should_save?(item, end_date)
            result << item
          else
            return result
          end
        end
      end
    end

    return result
  end

  def should_save?(item, end_date)
    (item.begin_at <= end_date)
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
    grab_events_from_xml.each do |event|
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
      elements << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
    end
    elements.join('&')
  end
end