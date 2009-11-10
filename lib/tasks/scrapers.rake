namespace :scrape do
  desc "This task will run all scrapers."
  task :all => ["scrape:xpress", "scrape:lastfm", "scrape:flixster"]

  desc "This task will scrape the Ottawa Xpress site."
  task :xpress do
    require "./lib/express_scraper.rb"
  end

  desc "This task will scrape the lastfm site."
  task :lastfm do
    lastfm = Lastfm.new('ontario')
    lastfm.create_events_from_until(Time.now, Time.now + 7.days)
  end
  
  desc "This task will scrape Flixster site."
  task :flixster do
    Flixster.new.create_all_movies_for_state_on_date("http://www.flixster.com/sitemap/theaters/CA/ON", Time.now)
  end

  desc "This task will scrape Meetup.com"
  task :meetup do
    Meetup.new('CA', 'ottawa').create_events_from_until(Time.now, Time.now + 7.days)
  end
end