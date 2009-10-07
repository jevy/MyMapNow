require 'flixster'
require 'graticule'

## run this with Rails' script/runner

f = Flixster.new
f.create_all_movies_for_state_on_date("http://www.flixster.com/sitemap/theaters/CA/ON", Time.now)
