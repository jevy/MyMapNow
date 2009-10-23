
root_url = 'http://www.ottawaxpress.ca/'
event_types = {:news => 'news', :music=>'music',
  :film=>'film', :stage=>'stage', :visual_arts=>'visual_arts', :books=>'books'}

def scrape(base_url, event_types)

  parser = ExpressParser.new()
  parser.populate_events
  
end




