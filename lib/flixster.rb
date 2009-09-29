require 'hpricot'
require 'open-uri'
require 'uri'

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

    #doc = open(generateURL(theatreUrl, date)) { |f| Hpricot(f) }
    doc = Hpricot open theatreUrl
    name = doc.at("//input[@name='name']")['value']
    print "Theatre #{name}:"
    address = doc.at("//input[@name='address']")['value']
    city = doc.at("//input[@name='city']")['value']
    region = doc.at("//input[@name='state']")['value']
    fullAddress = address + ", " + city + ", " + region

    # The movies and times alternate between two seperate, but sequential divs
    # Create two arrays, then match them up
    movieNames = []
    doc.search("//div[@class='mtitle']//a").each { |e| movieNames << e.inner_text }
    movieNames.each { |movie| movie = stringCleanup(movie) }

    movieTimesDivs = doc.search("//div[@class='times']")

    movieTimesDivs.each_index do |i|
      stringCleanup(movieTimesDivs[i].inner_text).split(',').each do |time|
        print "."
        movie = Item.create(:title => movieNames[i],
                            :begin_at => convertTimeStringToDate(date, time).to_s,
                            :address => fullAddress,
                            :kind => 'event')
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

  # Call this with the first state/province page
  def getAllTheaterLinks(url)
    resultLinks = []
    scrapeTheatreListingPaginationLinks(url).each do |pageUrl|
      resultLinks << scrapeTheaterLinksFromThisPage(pageUrl)
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
