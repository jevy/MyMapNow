namespace :scrape do
  desc "This task will run all scrapers."
  # Notice no flixster
  task :all => ["scrape:lastfm", "scrape:stubhub",
    "scrape:meetup", "scrape:eventbrite", "scrape:xpress"]

  desc "This task will scrape the Ottawa Xpress site."
  task(:xpress => :environment) do
    require 'lib/lastfm'
    start_date = Date.today
    end_date = Date.today.end_of_week

    start_date.upto(end_date) do |date|
      begin
        ExpressParser.new(date).parse_events.each do |event|
          event.save
        end
      rescue RuntimeError => error
        puts "Unable to parse events for #{date}, #{error.message}."
      end
    end
  end

  desc "This task will scrape the lastfm site."
  task(:lastfm => :environment) do
    items = LastfmRequest.new(:state => 'ontario', :country=>'canada')
    items.each {|i| i.save}
  end
  
  desc "This task will scrape Stubhub."
  task(:stubhub => :environment) do
    scraper = StubhubFeed.new
    scraper.search_terms = ["Canada", "Ottawa", "Toronto", "Ontario", "Montreal"]
    scraper.rows = 100
    scraper.pull_items_from_service
  end

  desc "This task will scrape Meetup.com"
  task(:meetup => :environment) do
    items = MeetupRequest.new(:city=>'ottawa', :state=>'ontario', :country=>'CA').pull_items_from_service
    items.each {|i| i.save if i.public_meetup}
  end

  desc "Scrape all of Flixster"
  task(:flixster => :environment) do
    f = Flixster.new
    f.create_all_movies_for_state_on_date("http://www.flixster.com/sitemap/theaters/CA/ON", Time.now)
  end

  desc "Scrape eventbrite"
  task(:eventbrite=>:environment) do
    e = EventbriteFeed.new
    e.pull_items_from_service
  end
end
