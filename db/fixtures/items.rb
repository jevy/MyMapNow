require 'item'

class Item
  def self.seed(*constraints, &block)
    SeedFu::Seeder.plant(self, *constraints, &block)
  end
end

Item.seed(:title) do |i|
  i.title = "Firefighters rescue canoeist from Ottawa River"
  i.description = "OTTAWA – The Ottawa Fire Department pulled two men in their 60s from the Ottawa River on Thursday morning after their canoe flipped in the rapids between Lemieux Island and the Chaudière Bridge.

  The men, who were both wearing personal flotation devices, had made it most of the way to the Ottawa shore with their overturned canoe when fire department watercraft picked them up. They were waterlogged but unharmed, said the fire department's Rick Giles, though one man suffered a gash on his shin and lost his shoes. The canoe fared worse – its wooden gunwales were cracked and the fibreglass dented.

  Paramedics arrived on the scene but the men refused medical attention, Giles said, adding that it was fortunate the men were wearing PFDs

  Ottawa police gave them a ride back to their car at Britannia.

  © Copyright (c) The Ottawa Citizen"
  i.address = "Chaudière Bridge, Ottawa, ON"
  i.url = 'http://www.ottawacitizen.com/Health/Firefighters+rescue+canoeist+from+Ottawa+River/1709594/story.html'
  i.date = Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.title = "Watch where you walk, City of Ottawa warns pedestrians"
  i.description = %Q{OTTAWA — The city kicked off a campaign Thursday aimed at reducing the number of injuries and deaths from cars hitting pedestrians, and part of it will involve trying to get walkers to take more responsibility for their actions.

  From 2004 to 2008, there were 1,668 pedestrian injuries and 32 deaths from collisions with cars in the city, and police say roughly half were caused by pedestrians crossing without the right of way or being inattentive.

  To combat this, the city’s campaign is called “Walk like your life depends on it,” and it encourages pedestrians to use marked crosswalks, to be more alert and not to take chances.

  The city is also installing more crosswalk signals with audio and visual warnings, including countdown timers that show pedestrians exactly how much time is left before they lose the right of way.

  The program will also include stepped-up police enforcement against jaywalkers (possible $50 fines) and drivers who fail to yield the right of way to walkers (possible $180 fines and three demerit points).

  The campaign launch at City Hall attracted a small protest from a group that thinks the campaign targets pedestrians unfairly and should focus more on getting drivers to respect walkers.

  Charles Akben-Marchand said that unlike in many cities, drivers in Ottawa don’t watch out for pedestrians enough, and if the city government is serious about creating a walkable city, it has to go after drivers more.

  “In other cities, if you put a foot off the curb, drivers stop,” he said. “Even if a pedestrian walks where they aren’t supposed to be, it still should be a driver's responsibility not to hit them.”}
  i.address = "Laurier Bridge, Ottawa, ON"
  i.url = 'http://www.ottawacitizen.com/news/ottawa/Watch+where+walk+City+Ottawa+warns+pedestrians/1709551/story.html'
  i.date = Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.title = "'Water works' at Chez Henri site"
  i.description = %Q{OTTAWA — ottawacitizen.com reader Christopher Busby snapped this photo Thursday afternoon after a construction shovel apparently struck a water main at the Chez Henri demolition site in Gatineau.

  Busby said city officials located the shut-off valve under interlocking brick on Promenade du Portage in front of the heritage building.

  The water was shut off at 3:40 p.m.

  © Copyright (c) The Ottawa Citizen}
  i.address = "179, Promenade du Portage, Gatineau, QC"
  i.url = 'http://www.ottawacitizen.com/news/ottawa/Water+works+Chez+Henri+site/1710150/story.html'
  i.date = Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.title = "Thirteen-year-old charged with robbery after mugging attempt"
  i.description = %Q{OTTAWA — A 13-year-old youth has been arrested after an early morning robbery on Rideau Street on Thursday.

  Police said that around 5 a.m., a 21-year-old male was walking down Rideau Street near King Edward Avenue when he was approached by a male — armed with a knife — who demanded his wallet. The 21-year-old ran away unharmed without giving up his wallet and called police.

  A suspect matching the description given by the victim was found by patrol officers not far from the intersection.

  A 13-year-old youth has been charged with one count of robbery. He will appear in court on June 23.

  © Copyright (c) The Ottawa Citizen}
  i.address = "Rideau Street and King Edward Avenue, Ottawa, ON"
  i.url = 'http://www.ottawacitizen.com/news/ottawa/Thirteen+year+charged+with+robbery+after+mugging+attempt/1710173/story.html'
  i.date = Date.parse('2009-06-18')
end

# Item.seed(:title) do |i|
#   i.title = ""
#   i.description = %Q{}
#   i.address = ""
#   i.url = ''
#   i.date = Date.parse('2009-06-18')
# end