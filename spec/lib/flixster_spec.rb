require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'
require 'hpricot'
require 'open-uri'

describe Flixster do
  before(:each) do
    @movie_at_amc_kanata = {
      :title      => "All About Steve",
      :begin_at   => Time.mktime(2009, 9, 28, 19, 20, 0),
      :address    => '801 Kanata Avenue, Kanata, ON',
      :latitude   => 45.312168,
      :longitude  => -75.9093546,
      :kind       => 'movie'
    }

    @flixster = Flixster.new
    @today = Time.mktime(2009, 9, 28, 19, 0, 0)
  end

  it "should create items from movies and times" do
    theatre = Venue.new
    theatre.name     = 'AMC Kanata'
    theatre.address  = '801 Kanata Avenue'
    theatre.city     = 'Kanata'
    theatre.state    = 'ON'

    movies_with_times = {"All About Steve" => [ Time.mktime(2009, 9, 28, 19, 20, 0),
                                                Time.mktime(2009, 9, 28, 12, 00, 0) ],
                         "9"               => [ Time.mktime(2009, 9, 28, 21, 20, 0),
                                                Time.mktime(2009, 9, 28, 21, 20, 0) ]}
    
    # Should receive a total of 4 calls
    Item.should_receive(:create).with(:title  =>  @movie_at_amc_kanata[:title],
                                      :begin_at =>  @movie_at_amc_kanata[:begin_at],
                                      :address => @movie_at_amc_kanata[:address],
                                      :latitude => @movie_at_amc_kanata[:latitude],
                                      :longitude => @movie_at_amc_kanata[:longitude],
                                      :kind => @movie_at_amc_kanata[:kind])
    Item.should_receive(:create).exactly(3).times

    @flixster.create_items_from_movies_hash(movies_with_times, theatre)
  end

  # Like here: http://www.flixster.com/showtimes/woodside-cinemas?date=20091006
  it "should find movies names that don't and do have links" do
    page = `cat spec/lib/testData/theatrePages/woodside-oct-7-with-movie-with-no-link`
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/woodside-cinemas?date=20091006", 
                         :response => page)

    doc = Hpricot open "http://www.flixster.com/showtimes/woodside-cinemas?date=20091006"
    movie_names = @flixster.extract_movie_names(doc)
    movie_names.should have(3).movies
    movie_names.should include("Do Knot Disturb")
    movie_names.should include("My Heart Goes Hooray! (Dil Bole Hadippa!)")
    movie_names.should include("Wanted (2008)")
  end

  it "should create movies for the specified a day (say today)" do
    @flixster.stub(:getAllTheaterLinks).and_return(["http://www.flixster.com/showtimes/amc-kanata-24"])
    todays_theatre_page = `cat spec/lib/testData/theatrePages/amc-sept-28`
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/amc-kanata-24?date=20090928", 
                        :response => todays_theatre_page)

    Item.should_receive(:create).exactly(88).times
    @flixster.create_all_movies_for_state_on_date('http://www.flixster.com/sitemap/theaters/CA/ON', @today)
  end

  it "should create movies for the specified a day (say in two weeks)" do
    @flixster.stub(:getAllTheaterLinks).and_return(["http://www.flixster.com/showtimes/amc-kanata-24"])
    tomorrows_theatre_page = `cat spec/lib/testData/theatrePages/amc-oct-7`
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/amc-kanata-24?date=20091007", 
                        :response => tomorrows_theatre_page)

    Item.should_receive(:create).exactly(85).times
    @flixster.create_all_movies_for_state_on_date('http://www.flixster.com/showtimes/amc-kanata-24',
                                        Time.mktime(2009,10,7,0,0,0))
  end

  it "should generate the url for the theatre on the given day" do
    amc_today_url = "http://www.flixster.com/showtimes/amc-kanata-24?date=20091006"
    amc_tomorrow_url = "http://www.flixster.com/showtimes/amc-kanata-24?date=20091007"
    silvercity_some_other_day = "http://www.flixster.com/showtimes/famous-players-silvercity-gloucester?date=20091023"
    base_url = "http://www.flixster.com/showtimes/amc-kanata-24"
    url = @flixster.url_for_theatre_with_date(base_url, Time.mktime(2009, 10, 6, 0, 0, 0))
    url.should eql amc_today_url
    url = @flixster.url_for_theatre_with_date(base_url, Time.mktime(2009, 10, 7, 0, 0, 0))
    url.should eql amc_tomorrow_url
    url = @flixster.url_for_theatre_with_date("http://www.flixster.com/showtimes/famous-players-silvercity-gloucester", Time.mktime(2009, 10, 23, 0, 0, 0))
    url.should eql silvercity_some_other_day
  end

  it "should associate movie names with times and return a hash" do
    theatrePage = `cat spec/lib/testData/theatrePages/amc-sept-28`
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/amc-kanata-24", 
                         :response => theatrePage)
    doc = Hpricot open "http://www.flixster.com/showtimes/amc-kanata-24"
    movie_names = @flixster.extract_movie_names(doc)
    movie_times_blocks = doc.search("//div[@class='times']")

    movies_with_times = @flixster.associate_movies_and_times(movie_names, movie_times_blocks, @today)
    movies_with_times.should have(20).movie_names
    movies_with_times.should have_key("9")
    times_for_movie_9 = movies_with_times["9"]
    times_for_movie_9.should include Time.mktime(2009, 9, 28, 20, 15, 0)
    times_for_movie_9.should include Time.mktime(2009, 9, 28, 15, 30, 0)

    movies_with_times.should have_key("Julie & Julia")
    times_for_movie_j_and_j = movies_with_times["Julie & Julia"]
    times_for_movie_j_and_j.should include Time.mktime(2009, 9, 28, 14, 15, 0)
    times_for_movie_j_and_j.should include Time.mktime(2009, 9, 28, 20, 30, 0)
  end

  it "should parse the time string and return the Time" do
    result = @flixster.convertTimeStringToDate(@today, "11:30 AM")
    result.should eql Time.mktime(2009,9,28,11,30,0)

    result = @flixster.convertTimeStringToDate(@today, "11:30 PM")
    result.should eql Time.mktime(2009,9,28,23,30,0)
  end

  it "should find all pagination links for multi page" do
    page1 = `cat spec/lib/testData/pagination/page1`
    page2 = `cat spec/lib/testData/pagination/page2`
    page3 = `cat spec/lib/testData/pagination/page3`
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/ON", :response => page1)
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/ON?page=2", :response => page2)
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/ON?page=3", :response => page3)
    links = @flixster.scrapeTheatreListingPaginationLinks("http://www.flixster.com/sitemap/theaters/CA/ON")
    links.should have(3).strings
    links.should include("http://www.flixster.com/sitemap/theaters/CA/ON")
    links.should include("http://www.flixster.com/sitemap/theaters/CA/ON?page=2")
    links.should include("http://www.flixster.com/sitemap/theaters/CA/ON?page=3")
  end

  it "should find no pagination links for single page" do
    page1 = `cat spec/lib/testData/pagination/NSpage1`
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/NS", :response => page1)
    links = @flixster.scrapeTheatreListingPaginationLinks("http://www.flixster.com/sitemap/theaters/CA/NS")
    links.should have(1).strings
    links.should include("http://www.flixster.com/sitemap/theaters/CA/NS")
  end

  it "should find links for theatre pages from a multi-page theatre list" do
    page1 = `cat spec/lib/testData/pagination/page1`
    page2 = `cat spec/lib/testData/pagination/page2`
    page3 = `cat spec/lib/testData/pagination/page3`
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/ON", :response => page1)
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/ON?page=2", :response => page2)
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/ON?page=3", :response => page3)
    links = @flixster.getAllTheaterLinks("http://www.flixster.com/sitemap/theaters/CA/ON")
    links.should include("http://www.flixster.com/showtimes/co-aurora-cinemas")
    links.should include("http://www.flixster.com/showtimes/revue-cinema")
  end

  it "should find links for theatre pages from a single-page theatre list" do
    page = `cat spec/lib/testData/pagination/NSpage1`
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/NS", :response => page)
    links = @flixster.getAllTheaterLinks("http://www.flixster.com/sitemap/theaters/CA/NS")
    links.should include("http://www.flixster.com/showtimes/empire-theatres-antigonish")
    links.should include("http://www.flixster.com/showtimes/empire-theatres-studio-7-cinemas")
  end

  it "should find theatre links from a single pagination page" do
    page = `cat spec/lib/testData/pagination/NSpage1`
    FakeWeb.register_uri(:get, "http://www.flixster.com/sitemap/theaters/CA/NS", :response => page)
    links = @flixster.scrapeTheaterLinksFromThisPage("http://www.flixster.com/sitemap/theaters/CA/NS")
    links.should include("http://www.flixster.com/showtimes/empire-theatres-antigonish")
    links.should include("http://www.flixster.com/showtimes/empire-theatres-studio-7-cinemas")
  end

  it "should not crash on a broken theatre page" do
    page = `cat spec/lib/testData/theatrePages/broken-theatre2`
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/famous-players-silvercity-gloucester?date=20091023", 
                         :response => page)
    lambda {@flixster.scrapeTheatrePage("http://www.flixster.com/showtimes/famous-players-silvercity-gloucester?date=20091023",
                              Time.mktime(2009, 10, 23, 0,0,0) )}.should_not raise_error

  end

end
