

#Run with script/runner lib/express_scraper.rb

root_url = 'http://www.ottawaxpress.ca/'
extension_url = 'music/listings.aspx'
parameters = "?date=#{Date.today.strftime "%Y%m%d"}&dateC=#{Date.today.strftime "%Y%m00"}"

range = (Date.today..1.months.since(Date.today))




doc = Hpricot open(root_url+extension_url+parameters, 'User-Agent'=>'ruby')
parser = ExpressParser.new(doc,root_url)
events = parser.parse_events
events.each{|event|  puts "Adding event #{event.inspect}"; event.save}