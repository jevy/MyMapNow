require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe Flixster do
  before(:each) do
    @movie_at_cineforum = {
      :title      => "Cocksucker Blues",
      :begin_at   => Time.mktime(2009, 9, 27, 19, 0, 0),
      :address    => '463 Bathurst St, Toronto, ON'
    }
    @movie_at_amc_kanata = {
      :title      => "All About Steve",
      :begin_at   => Time.mktime(2009, 9, 28, 19, 20, 0),
      :address    => '801 Kanata Avenue, Kanata, ON',
      :kind       => 'event'
    }

    @flixster = Flixster.new
    @today = Time.mktime(2009, 9, 28, 19, 0, 0)
  end

  it "should create an item for the movie" do
    page = `cat spec/lib/testData/theatrePages/amc-sept-28`
    FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/amc-kanata-24", :response => page)
    myItem = mock("Item")
    # Should there be a mock here?
    myItem.should_receive(:create).with(:title      => @movie_at_amc_kanata[:title],
                                        :begin_at   => @movie_at_amc_kanata[:begin_at],
                                        :address    => @movie_at_amc_kanata[:address],
                                        :kind       => 'event')
    @flixster.scrapeTheatrePage("http://www.flixster.com/showtimes/amc-kanata-24", @today)
  end

  it "should associate movie names with times and return a hash"

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

  it "should find movies for the specified day"
  it "should geocode the movie theatre to the right place"
  it "should parse a big movie theatre page and extract movies"
  it "should parse a small movie theatre page and extract movies"
  it "should extract movies and not have duplicates"

end
