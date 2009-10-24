require 'meetup'

## run this with Rails' script/runner

meetup = Meetup.new('CA', 'ottawa')
meetup.create_events_from_until(Time.now, Time.now + 7.days)
