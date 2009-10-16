require 'lastfm'

## run this with Rails' script/runner

lastfm = Lastfm.new('ottawa')
lastfm.create_events_from_until(Time.now, Time.now + 7.days)
