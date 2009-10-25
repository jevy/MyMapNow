

root_url = 'http://www.ottawaxpress.ca/'
extension_url = 'music/listings.aspx'
range = (Date.today..1.months.since(Date.today))



doc = Hpricot open(root_url+extension_url, 'User-Agent'=>'ruby')
parser = ExpressParser.new(doc,root_url)
events = parser.parse_events
#events.each{|event|  event.save}
puts events






