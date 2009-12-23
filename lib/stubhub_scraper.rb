#require 'stubhub_feed.rb'

scraper = StubhubFeed.new
scraper.search_terms = ["Canada", "Ottawa", "Toronto", "Ontario", "Montreal"]
scraper.rows = 100
scraper.pull_items_from_service
