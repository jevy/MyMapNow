

#Run with script/runner lib/express_scraper.rb
parser = ExpressParser.new(Date.today)
events = parser.parse_events
events.each{|event|  puts "Adding event #{event.inspect}"; event.save}