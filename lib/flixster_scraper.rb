require 'flixster'
require 'graticule'

## run this with Rails' script/runner

geocoder = Graticule.service(:google).new "ABQIAAAAFRf0kHHTAwfnYFoh1eZH6BRi_QCTkdRWobLL_A5W6S7qSSFeQRRqJG7tcFKh_yySJlsACF58wUTsLg"
f = Flixster.new(geocoder)
f.scrapeFromAllTheatreAtStateURL("http://www.flixster.com/sitemap/theaters/CA/ON")
