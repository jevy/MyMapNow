namespace :scrape do
  desc "This task will run all scrapers."
  task :all => ["scrape:lastfm",
    "scrape:meetup", "scrape:eventbrite", "scrape:xpress","scrape:stubhub"]

  desc "This task will scrape the Ottawa Xpress site."
  task(:xpress => :environment) do
    Xpress.new.pull_items_from_service_and_save
  end

  desc "This task will scrape the lastfm site."
  task(:lastfm => :environment) do
    Lastfm.new.pull_items_from_service_and_save
  end
  
  desc "This task will scrape Stubhub."
  task(:stubhub => :environment) do
    Stubhub.new.pull_items_from_service_and_save
  end

  desc "This task will scrape Meetup.com"
  task(:meetup => :environment) do
     Meetup.new.pull_items_from_service_and_save
  end

  desc "Scrape eventbrite"
  task(:eventbrite=>:environment) do
    Eventbrite.new.pull_items_from_service_and_save
  end

end
