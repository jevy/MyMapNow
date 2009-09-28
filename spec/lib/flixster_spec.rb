require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe Flixster do
  before(:each) do
    @movie_at_cineforum = {
      :title => "Cocksucker Blues",
      :begin_at => Time.mktime(2009, 9, 27, 19, 0, 0),
      :address => '463 Bathurst St, Toronto, ON'
    }
    @movie_at_amc_kanata = {
      :title => "All About Steve",
      :begin_at => Time.mktime(2009, 9, 27, 19, 20, 0),
      :description => "Insert movie description here",
      :address => '801 Kanata Avenue, Kanata, ON'
    }

    @flixster = Flixster.new
    @today = Time.mktime(2009, 9, 27, 19, 0, 0)
  end

  it "should parse a big movie theatre page and extract movies" do
    #page = `cat spec/lib/testData/amc-kanata-24-html`
    #FakeWeb.register_uri(:get, "http://www.flixster.com/showtimes/amc-kanata-24", :response => page)
    item = mock_model(Item)
    Item.should_receive(:save).with(:title       => @movie_at_amc_kanata[:title],
                                      :begin_at    => @movie_at_amc_kanata[:begin_at],
                                      :description => @movie_at_amc_kanata[:description],
                                      :address     => @movie_at_amc_kanata[:address])
    @flixster.scrapeTheatrePage("spec/lib/testData/amc-kanata-24-httrack.html", @today)
  end


  it "should parse a small movie theatre page and extract movies"
  it "should extract movies and not have duplicates"
  it "should find links for each theatre page"
  it "should find movies for the next week"
  it "should find all movie times for the next week from state url"
  it "should geocode the movie theatre to the right place"

end
