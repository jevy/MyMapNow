require 'flixster'
require 'graticule'

## run this with Rails' script/runner

f = Flixster.new
f.scrapeFromAllTheatreAtStateURL("http://www.flixster.com/sitemap/theaters/CA/ON", Time.now)
