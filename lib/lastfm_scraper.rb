require 'lastfm'

## run this with Rails' script/runner

loc = Location.new(nil, 'ontario', 'canada')
items = Lastfm.get_items(loc, Time.now, Time.now + 7.days)
items.each {|i| i.save}
