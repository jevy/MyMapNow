require 'hpricot'
require 'open-uri'
require 'uri'

# * The Flixster site as a listing of all provinces/states here (called province base URL)
# http://www.flixster.com/sitemap/theaters
# * Each prov/state page may have multiple pagination pages and the pages
# contain many links to theatres.
# * Each theatre page has many movies and showtimes for those movies
class Flixster

  def create_all_movies_for_state_on_date(state_base_url, date)
    theatre_base_urls = getAllTheaterLinks(state_base_url)

    theatre_base_urls.each do |url|
      url_with_date = url_for_theatre_with_date(url, date)
      movies_with_times = scrapeTheatrePage(url_with_date, date)
      theatre = extract_venue(url_with_date)
      create_items_from_movies_hash(movies_with_times, theatre)
    end

  end

  # Designed for a single theatre's page
  def scrapeTheatrePage(theatreUrl, date)

    doc = Hpricot open theatreUrl

    # The movies and times alternate between two seperate, but sequential divs
    # Create two arrays, then match them up
    movie_names = extract_movie_names(doc)
    movie_times_blocks = doc.search("//div[@class='times']")
    movies_with_times = associate_movies_and_times(movie_names, movie_times_blocks, date)
  end

  #
  # Helper methods
  #
  
  def extract_venue(url)

    doc = Hpricot open url

    theatre           = Venue.new
    theatre.name      = doc.at("//input[@name='name']")['value']
    theatre.address   = doc.at("//input[@name='address']")['value']
    theatre.city      = doc.at("//input[@name='city']")['value']
    theatre.state     = doc.at("//input[@name='state']")['value']

    return theatre
  end

  def extract_movie_names(doc)
    movieNames = []
    doc.search("//div[@class='mtitle']").each do |e| 
      e.search('span').remove
      movieNames << e.inner_text.strip
    end

    movieNames.each { |movie| movie = stringCleanup(movie) }
  end

  # returns: a hash with the key as the movie and the value as an array of movie times
  def associate_movies_and_times(movie_names, movie_times_blocks, date)
    result = {}
    movie_times_blocks.each_index do |i|
      stringCleanup(movie_times_blocks[i].inner_text).split(',').each do |time|
        if result["#{movie_names[i]}"].nil? 
          result["#{movie_names[i]}"] = [convertTimeStringToDate(date, time)]
        else 
          result["#{movie_names[i]}"].concat [convertTimeStringToDate(date, time)]
        end
      end
    end

    return result
  end

  def create_items_from_movies_hash(movies_with_times, theatre)
    coordinates = theatre.coordinates

    movies_with_times.each_pair do |movie_name, times|
      times.each do |time|
        Item.create(:title     => movie_name,
                    :begin_at  => time,
                    :address   => theatre.full_address,
                    :latitude  => coordinates[0],
                    :longitude => coordinates[1],
                    :kind      => 'event')
      end
    end

  end

  def convertTimeStringToDate(date, timeString) 
    Time.parse(timeString, date) 
  end

  def url_for_theatre_with_date(theatre_url,date)
    return theatre_url + "?date=" + date.strftime("%Y%m%d")
  end

  # Call this with the first state/province page
  # This will get all the urls to the theatres even if there are multiple
  # pagination pages for the state/prov
  def getAllTheaterLinks(base_url)
    resultLinks = []
    scrapeTheatreListingPaginationLinks(base_url).each do |pageUrl|
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
