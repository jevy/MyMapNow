require 'hpricot'
require 'open-uri'
require 'uri'

# * The Flixster site as a listing of all provinces/states here:
# http://www.flixster.com/sitemap/theaters
# * Each prov/state page may have multiple pagination pages and the pages
# contain many links to theatres.
# * Each theatre page has many movies and showtimes for those movies
class Flixster
  def scrapeFromAllTheatreAtStateURL(url)
    doc = Hpricot(open(url))
    pageLinks = getPageLinks(doc, url)

    if pageLinks.nil?
      puts url
      scrapeTheatreListingPage(url)
    else
      pageLinks.each do |pageLink|
        puts pageLink
        scrapeTheatreListingPage(pageLink)
      end
    end
    
  end

  def scrapeTheatreListingPage(url)
    doc = Hpricot(open(url))
    theaterLinks = getTheaterLinks(doc, url)

    theaterLinks.each { |url| scrapeTheatre(url, Time.now) }
  end

  # Designed for a single theatre's page
  def scrapeTheatrePage(theatreUrl, date)

    doc = Hpricot open theatreUrl

    name      = doc.at("//input[@name='name']")['value']
    address   = doc.at("//input[@name='address']")['value']
    city      = doc.at("//input[@name='city']")['value']
    region    = doc.at("//input[@name='state']")['value']
    fullAddress = address + ", " + city + ", " + region
    print "Theatre #{name}:"

    # The movies and times alternate between two seperate, but sequential divs
    # Create two arrays, then match them up
    movieNames = []
    doc.search("//div[@class='mtitle']//a").each { |e| movieNames << e.inner_text }
    movieNames.each { |movie| movie = stringCleanup(movie) }

    movieTimesDivs = doc.search("//div[@class='times']")

    movieTimesDivs.each_index do |i|
      stringCleanup(movieTimesDivs[i].inner_text).split(',').each do |time|
        print "."
        movie = Item.create(:title    => movieNames[i],
                            :begin_at => convertTimeStringToDate(date, time),
                            :address  => fullAddress,
                            :kind     => 'event')
      end
    end
    print "\n"

  end

  #
  # Helper methods
  #

  def convertTimeStringToDate(date, timeString) 
    Time.parse(timeString, date) 
  end

  #def generateURL(theatreUrl,date)
  #  return theatreUrl + "?date=" + date.strftime("%Y%m%d")
  #end

  # Call this with the first state/province page
  def getAllTheaterLinks(url)
    resultLinks = []
    scrapeTheatreListingPaginationLinks(url).each do |pageUrl|
      resultLinks.concat scrapeTheaterLinksFromThisPage(pageUrl)
    end
    return resultLinks
  end

  def scrapeTheatreListingPaginationLinks(url)
    pageLinks = []
    doc = Hpricot open url
    (doc/"div.pagination:first//a").each { |a| pageLinks << "http://www.flixster.com" + a[:href] } # Nil if this is the only page
    return Array.[](url) if pageLinks.empty?
    return pageLinks
  end

  def scrapeTheaterLinksFromThisPage(url)
    theaterLinks = []
    doc = Hpricot open url
    (doc/"div.theater//h3//a").each { |a| theaterLinks << "http://www.flixster.com" + a[:href] }
    return theaterLinks
  end

  def stringCleanup(string)
    string.gsub!(/[\n]+/, "")
    string.gsub!(/[\t]+/, "")
    string.gsub!(/\s{2,}/, " ")
    string.strip
  end
end
