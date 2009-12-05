require 'meetup'

## run this with Rails' script/runner

loc = Location.new('ottawa', 'ontario', 'CA')
items = Meetup.get_items(loc, Time.now, Time.now + 7.days)
items.each {|i| i.save if i.public_meetup}
