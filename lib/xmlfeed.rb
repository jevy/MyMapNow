require 'nokogiri'

class XMLFeed
  attr_reader :event_queue  # FIXME: I should be private!  Needs to be public for testing?

  @feed_has_pagination = false

end

class InvalidLocationException < Exception
end
