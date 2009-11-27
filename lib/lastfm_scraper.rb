require 'lastfm'

## run this with Rails' script/runner

lastfm = Lastfm.new(nil, 'ontario', 'canada')
lastfm.create_events_from_until(Time.now, Time.now + 7.days)
