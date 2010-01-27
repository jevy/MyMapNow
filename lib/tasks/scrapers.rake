namespace :scrape do
  desc "This task will run all scrapers."
  task :all => ["scrape:lastfm", "scrape:stubhub",
    "scrape:meetup", "scrape:eventbrite", "scrape:xpress"]

  desc "This task will scrape the Ottawa Xpress site."
  task(:xpress => :environment) do
    Express.new.pull_items_from_service

    start_date = Date.today
    end_date = Date.today.end_of_week

    start_date.upto(end_date) do |date|
      begin
        Express.new(date).parse_events.each do |event|
          event.save
        end
      rescue RuntimeError => error
        puts "Unable to parse events for #{date}, #{error.message}."
      end
    end
  end

  desc "This task will scrape the lastfm site."
  task(:lastfm => :environment) do
    items = Lastfm.new.pull_items_from_service
    items.each {|i| i.save}
  end
  
  desc "This task will scrape Stubhub."
  task(:stubhub => :environment) do
    Stubhub.new.pull_items_from_service
  end

  desc "This task will scrape Meetup.com"
  task(:meetup => :environment) do
    items = Meetup.new.pull_items_from_service
    items.each {|i| i.save if !i.city_wide}
  end

  desc "Scrape all of Flixster"
  task(:flixster => :environment) do
    raise RuntimeError, "Not To Be Run!"
    f = Flixster.new
    f.create_all_movies_for_state_on_date("http://www.flixster.com/sitemap/theaters/CA/ON", Time.now)
  end

  desc "Scrape eventbrite"
  task(:eventbrite=>:environment) do
    Eventbrite.new.pull_items_from_service
  end
end
