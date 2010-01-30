require 'hpricot'
require 'open-uri'
require 'uri'

class Flixster

  def create_all_movies_for_state_on_date(state_base_url, date)
    theatre_base_urls = get_theatre_links(state_base_url)

    theatre_base_urls.each do |url|
      url_with_date = url_for_theatre_with_date(url, date)
      movies_with_times = scrape_theatre_page(url_with_date, date)
      theatre = extract_venue(url_with_date)
      create_items_from_movies_hash(movies_with_times, theatre)
    end
  end

  def scrape_theatre_page(url, date)
    doc = open_url(url)

    movie_names = extract_movie_names(doc)
    movie_times_blocks = doc.search("//div[@class='times']")
    associate_movies_and_times(movie_names, movie_times_blocks, date)
  end
  
  def extract_venue(url)
    theatre = Venue.new
    begin
      doc = open_url(url)
      doc.at("//input[@name='name']")['value'].nil?
      theatre.name = doc.at("//input[@name='name']")['value']
      theatre.address = doc.at("//input[@name='address']")['value']
      theatre.city = doc.at("//input[@name='city']")['value']
      theatre.state = doc.at("//input[@name='state']")['value']
    rescue
      puts url
    end
    return theatre
  end

  def extract_movie_names(doc)
    doc.search("//div[@class='mtitle']").map do |e|
      string_cleanup(movie_name(e))
    end
  end

  def movie_name(element)
    element.search('span').remove.inner_text
    element.inner_text.strip
  end

  def associate_movies_and_times(movie_names, movie_times_blocks, date)
    times = movie_times_blocks.map{|time_block| movie_times_to_date(time_block, date) }
    movie_names.to_hash(times)
  end

  def movie_times_to_date(times, date)
    movie_times(times).map{|time| Time.parse(time, date)}
  end

  def movie_times(movie_times_string)
    string_cleanup(movie_times_string.inner_text).split(',')
  end

  def create_items_from_movies_hash(movies_with_times, theatre)
#    coordinates = theatre.coordinates
    movies_with_times.each_pair do |movie_name, times|
      times.each do |time|
        Item.create(:title => movie_name,
          :begin_at => time,
          :address => theatre.full_address,
#          :latitude => coordinates[0],
#          :longitude => coordinates[1],
          :kind => 'movie')
      end
    end
  end

  def url_for_theatre_with_date(theatre_url,date)
    return theatre_url + "?date=" + date.strftime("%Y%m%d")
  end

  def get_theatre_links(base_url)
    scrape_theatre_pagination_links(base_url).map do |url|
      theatre_links_from_url(url)
    end.flatten
  end

  def scrape_theatre_pagination_links(url)
    page_links = (open_url(url)/"div.pagination:first//a").map do |link|
      "http://www.flixster.com" + link[:href] 
    end
    page_links.empty? ?  [url] : page_links
  end

  def theatre_links_from_url(url)
    (open_url(url)/"div.theater//h3//a").map do|link|
      "http://www.flixster.com" + link[:href] 
    end
  end

  def string_cleanup(string)
    string.gsub!(/\s{2,}/, " ")
    string.strip
  end

  def open_url(url)
    Hpricot open(url)
  end
end

class Array
  def to_hash(other)
    Hash[ *(0...self.size()).inject([]) { |arr, ix| arr.push(self[ix], other[ix]) } ]
  end
end

