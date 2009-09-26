require 'hpricot'
require 'open-uri'

class Flixster
  def initialize(g)
    @geocoder = g
  end

  def scrapeFromAllTheatreAtStateURL(url)
    doc = Hpricot(open(url))
    pageLinks = getPageLinks (doc, url)

    if pageLinks.nil?
      scrapeTheatreListingPage(url)
    else
      pageLinks.each do |pageLink|
        scrapeTheatreListingPage(pageLink)
      end
    end
    
  end

  def scrapeTheatreListingPage(url)
    doc = Hpricot(open(url))
    theaterLinks = getTheaterLinks (doc, url)

    theaterLinks.each { |url| scrapeTheatre(url, Time.now) }
  end

  # Designed for a single theatre's page
  def scrapeTheatre(theatreUrl,date)

    doc = open(generateURL(theatreUrl, date)) { |f| Hpricot(f) }
    name = doc.at("//input[@name='name']")['value']
    print "Theatre #{name}:"
    address = doc.at("//input[@name='address']")['value']
    city = doc.at("//input[@name='city']")['value']
    region = doc.at("//input[@name='state']")['value']
    fullAddress = address + ", " + city + ", " + region

    location = @geocoder.locate fullAddress

    # The movies and times alternate between two seperate, but sequential divs
    # Create two arrays, then match them up
    movieNames = []
    doc.search("//div[@class='mtitle']//a").each { |e| movieNames << e.inner_text }
    movieNames.each { |movie| movie = stringCleanup(movie) }

    movieTimesDivs = doc.search("//div[@class='times']")

    movieTimesDivs.each_index do |i|
      stringCleanup(movieTimesDivs[i].inner_text).split(',').each do |time|
        print "."
        movie = Item.new
        movie.title = movieNames[i]
        movie.description = "Insert movie description here"
        movie.begin_at = convertTimeStringToDate(date, time).to_s
        movie.address = fullAddress
        movie.latitude = location.latitude
        movie.longitude = location.longitude
        movie.kind = 'event'
        movie.save
      end
    end
    print "\n"

  end

  def convertTimeStringToDate(date, timeString) 
    Time.parse(timeString, date) 
  end

  def generateURL(theatreUrl,date)
    return theatreUrl + "?date=" + date.strftime("%Y%m%d")
  end

  def getPageLinks (doc, url)
    pageLinks = []
    (doc/"div.pagination//a").each { |a| pageLinks << "http://" + url.split('/')[2] + a[:href] } # Nil if this is the only page
    return pageLinks
  end

  def getTheaterLinks (doc, url)
    theaterLinks = []
    (doc/"div.theater//h3//a").each { |a| theaterLinks << "http://" + url.split('/')[2] + a[:href] }
    return theaterLinks
  end

  def stringCleanup(string)
    string.gsub!(/[\n]+/, "")
    string.gsub!(/[\t]+/, "")
    string.gsub!(/\s{2,}/, " ")
    string.strip
  end
end
