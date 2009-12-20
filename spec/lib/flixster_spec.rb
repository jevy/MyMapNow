require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'
require 'hpricot'
require 'open-uri'

describe Flixster do

  PAGE_1 = `cat spec/lib/testData/pagination/page1`
  PAGE_2 = `cat spec/lib/testData/pagination/page2`
  PAGE_3 = `cat spec/lib/testData/pagination/page3`
  NS_PAGE_1 = `cat spec/lib/testData/pagination/NSpage1`
  AMC_SEP_28 =`cat spec/lib/testData/theatrePages/amc-sept-28`
  NS_THEATRES_URL = "http://www.flixster.com/sitemap/theaters/CA/NS"
  ON_THEATRES_URL = "http://www.flixster.com/sitemap/theaters/CA/ON"

  before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    @flixster = Flixster.new
    @today = Time.mktime(2009, 9, 28, 19, 0, 0)
  end

  it "should create items from movies and times" do
    theatre = Venue.new
    theatre.name = 'AMC Kanata'
    theatre.address = '801 Kanata Avenue'
    theatre.city = 'Kanata'
    theatre.state = 'ON'

    movies_with_times = {"9" => [ Time.mktime(2009, 9, 28, 21, 20, 0),
        Time.mktime(2009, 9, 28, 21, 20, 0) ],
      "All About Steve" => [ Time.mktime(2009, 9, 28, 19, 20, 0),
        Time.mktime(2009, 9, 28, 12, 00, 0) ]}
    
    # Should receive a total of 4 calls
    Item.should_receive(:create).exactly(2).times
    Item.should_receive(:create).once.with(hash_including(:title  =>  "All About Steve",
        :begin_at => Time.mktime(2009, 9, 28, 19, 20, 0) ,
        :address =>  '801 Kanata Avenue, Kanata, ON',
        :kind => 'movie'))
    Item.should_receive(:create).exactly(1).times

    @flixster.create_items_from_movies_hash(movies_with_times, theatre)
  end

  # Like here: http://www.flixster.com/showtimes/woodside-cinemas?date=20091006
  it "should find movies names that don't and do have links" do
    page = `cat spec/lib/testData/theatrePages/woodside-oct-7-with-movie-with-no-link`
    url = "http://www.flixster.com/showtimes/woodside-cinemas?date=20091006"
    register_url_with_page(url, page)

    doc = Hpricot(open(url))
    movie_names = @flixster.extract_movie_names(doc)
    movie_names.should have(3).movies
    movie_names.should include("Do Knot Disturb")
    movie_names.should include("My Heart Goes Hooray! (Dil Bole Hadippa!)")
    movie_names.should include("Wanted (2008)")
  end

  it "should create movies for the specified a day (say today)" do
    @flixster.stub(:get_theatre_links).and_return(["http://www.flixster.com/showtimes/amc-kanata-24"])
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/amc-kanata-24?date=20090928", 
      :response => AMC_SEP_28)

    Item.should_receive(:create).exactly(88).times
    @flixster.create_all_movies_for_state_on_date(ON_THEATRES_URL, @today)
  end

  it "should create movies for the specified a day (say in two weeks)" do
    @flixster.stub(:get_theatre_links).and_return(["http://www.flixster.com/showtimes/amc-kanata-24"])
    tomorrows_theatre_page = `cat spec/lib/testData/theatrePages/amc-oct-7`
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/amc-kanata-24?date=20091007", 
      :response => tomorrows_theatre_page)

    Item.should_receive(:create).exactly(85).times
    @flixster.create_all_movies_for_state_on_date('http://www.flixster.com/showtimes/amc-kanata-24',
      Time.mktime(2009,10,7,0,0,0))
  end

  it "should generate the url for the theatre on the given day" do
    url = "http://www.flixster.com/showtimes/amc-kanata-24"
    amc_today_url = "http://www.flixster.com/showtimes/amc-kanata-24?date=20091006"
    amc_tomorrow_url = "http://www.flixster.com/showtimes/amc-kanata-24?date=20091007"
    silvercity_some_other_day = "http://www.flixster.com/showtimes/famous-players-silvercity-gloucester?date=20091023"
    base_url = "http://www.flixster.com/showtimes/amc-kanata-24"
    url = @flixster.url_for_theatre_with_date(base_url, Time.mktime(2009, 10, 6, 0, 0, 0))
    url.should eql(amc_today_url)
    url = @flixster.url_for_theatre_with_date(base_url, Time.mktime(2009, 10, 7, 0, 0, 0))
    url.should eql(amc_tomorrow_url)
    url = @flixster.url_for_theatre_with_date("http://www.flixster.com/showtimes/famous-players-silvercity-gloucester", Time.mktime(2009, 10, 23, 0, 0, 0))
    url.should eql(silvercity_some_other_day)
  end

  it "should associate movie names with times and return a hash" do
    theatre_page = `cat spec/lib/testData/theatrePages/amc-sept-28`
    url = "http://www.flixster.com/showtimes/amc-kanata-24"
    register_url_with_page(url, theatre_page)
    doc = Hpricot open(url)
    movie_names = @flixster.extract_movie_names(doc)
    movie_times_blocks = doc.search("//div[@class='times']")

    movies_with_times = @flixster.associate_movies_and_times(movie_names, movie_times_blocks, @today)
    movies_with_times.should have(20).movie_names
    movies_with_times.should have_key("9")
    times_for_movie_9 = movies_with_times["9"]
    times_for_movie_9.should include(Time.mktime(2009, 9, 28, 20, 15, 0))
    times_for_movie_9.should include(Time.mktime(2009, 9, 28, 15, 30, 0))

    movies_with_times.should have_key("Julie & Julia")
    times_for_movie_j_and_j = movies_with_times["Julie & Julia"]
    times_for_movie_j_and_j.should include(Time.mktime(2009, 9, 28, 14, 15, 0))
    times_for_movie_j_and_j.should include(Time.mktime(2009, 9, 28, 20, 30, 0))
  end

  it "should find all pagination links for multi page" do
    load_default_pages(ON_THEATRES_URL)
    links = @flixster.scrape_theatre_pagination_links(ON_THEATRES_URL)
    links.should have(3).strings
    links.should include(append_page_suffix(ON_THEATRES_URL))
    links.should include(append_page_suffix(ON_THEATRES_URL, :page => 2))
    links.should include(append_page_suffix(ON_THEATRES_URL, :page => 3))
  end

  it "should find no pagination links for single page" do
    register_url_with_page(NS_THEATRES_URL, NS_PAGE_1)
    links = @flixster.scrape_theatre_pagination_links(NS_THEATRES_URL)
    links.should have(1).strings
    links.should include(NS_THEATRES_URL)
  end

  it "should find links for theatre pages from a multi-page theatre list" do
    load_default_pages(ON_THEATRES_URL)
    links = @flixster.get_theatre_links(ON_THEATRES_URL)
    links.should include("http://www.flixster.com/showtimes/co-aurora-cinemas")
    links.should include("http://www.flixster.com/showtimes/revue-cinema")
  end

  it "should find links for theatre pages from a single-page theatre list" do
    register_url_with_page(NS_THEATRES_URL, NS_PAGE_1)
    links = @flixster.get_theatre_links(NS_THEATRES_URL)
    links.should include("http://www.flixster.com/showtimes/empire-theatres-antigonish")
    links.should include("http://www.flixster.com/showtimes/empire-theatres-studio-7-cinemas")
  end

  it "should find theatre links from a single pagination page" do
    register_url_with_page(NS_THEATRES_URL, NS_PAGE_1)
    links = @flixster.theatre_links_from_url(NS_THEATRES_URL)
    links.should include("http://www.flixster.com/showtimes/empire-theatres-antigonish")
    links.should include("http://www.flixster.com/showtimes/empire-theatres-studio-7-cinemas")
  end

  it "should not crash on a broken theatre page" do
    page = `cat spec/lib/testData/theatrePages/broken-theatre2`
    url = "http://www.flixster.com/showtimes/famous-players-silvercity-gloucester?date=20091023"
    register_url_with_page(url, page)
    lambda {@flixster.scrape_theatre_page(url, Time.mktime(2009, 10, 23, 0,0,0) )}.should_not raise_error
  end

  def load_default_pages(page_prefix)
    register_url_with_page(append_page_suffix(page_prefix), PAGE_1)
    register_url_with_page(append_page_suffix(page_prefix, :page => 2), PAGE_2)
    register_url_with_page(append_page_suffix(page_prefix, :page => 3), PAGE_3)
  end

  def register_url_with_page(url, page)
    FakeWeb.register_uri(:get, url, :response => page)
  end

  def append_page_suffix(url = ON_THEATRES_URL, args={})
    url = url.dup
    url.concat('?') unless args.empty?
    args.each_pair do |key, value|
      url.concat "#{key}=#{value}"
    end
    url
  end
end
