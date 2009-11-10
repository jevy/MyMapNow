

#Run with script/runner lib/express_scraper.rb
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