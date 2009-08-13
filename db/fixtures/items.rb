require 'item'

class Item
  def self.seed(*constraints, &block)
    SeedFu::Seeder.plant(self, *constraints, &block)
  end
end

Item.seed(:title) do |i|
  i.kind = 'news'
  i.title = "Firefighters rescue canoeist from Ottawa River"
  i.description = "OTTAWA – The Ottawa Fire Department pulled two men in their 60s from the Ottawa River on Thursday morning after their canoe flipped in the rapids between Lemieux Island and the Chaudière Bridge.

  The men, who were both wearing personal flotation devices, had made it most of the way to the Ottawa shore with their overturned canoe when fire department watercraft picked them up. They were waterlogged but unharmed, said the fire department's Rick Giles, though one man suffered a gash on his shin and lost his shoes. The canoe fared worse – its wooden gunwales were cracked and the fibreglass dented.

  Paramedics arrived on the scene but the men refused medical attention, Giles said, adding that it was fortunate the men were wearing PFDs

  Ottawa police gave them a ride back to their car at Britannia.

  © Copyright (c) The Ottawa Citizen"
  i.address = "Chaudière Bridge, Ottawa, ON"
  i.url = 'http://www.ottawacitizen.com/Health/Firefighters+rescue+canoeist+from+Ottawa+River/1709594/story.html'
  i.begin_at = 4.days.from_now #Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.kind = 'news'
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
  i.begin_at = 5.days.from_now #Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.kind = 'news'
  i.title = "'Water works' at Chez Henri site"
  i.description = %Q{OTTAWA — ottawacitizen.com reader Christopher Busby snapped this photo Thursday afternoon after a construction shovel apparently struck a water main at the Chez Henri demolition site in Gatineau.

  Busby said city officials located the shut-off valve under interlocking brick on Promenade du Portage in front of the heritage building.

  The water was shut off at 3:40 p.m.

  © Copyright (c) The Ottawa Citizen}
  i.address = "179, Promenade du Portage, Gatineau, QC"
  i.url = 'http://www.ottawacitizen.com/news/ottawa/Water+works+Chez+Henri+site/1710150/story.html'
  i.begin_at = 3.days.from_now #Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.kind = 'news'
  i.title = "Thirteen-year-old charged with robbery after mugging attempt"
  i.description = %Q{OTTAWA — A 13-year-old youth has been arrested after an early morning robbery on Rideau Street on Thursday.

  Police said that around 5 a.m., a 21-year-old male was walking down Rideau Street near King Edward Avenue when he was approached by a male — armed with a knife — who demanded his wallet. The 21-year-old ran away unharmed without giving up his wallet and called police.

  A suspect matching the description given by the victim was found by patrol officers not far from the intersection.

  A 13-year-old youth has been charged with one count of robbery. He will appear in court on June 23.

  © Copyright (c) The Ottawa Citizen}
  i.address = "Rideau Street and King Edward Avenue, Ottawa, ON"
  i.url = 'http://www.ottawacitizen.com/news/ottawa/Thirteen+year+charged+with+robbery+after+mugging+attempt/1710173/story.html'
  i.begin_at = 6.days.from_now #Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Ottawa Fringe Festival"
  i.description = %Q{A Fringe Festival is a forum that unites artists and audiences in a fun, exploratory environment. The guiding principles of the Fringe include unrestricted artistic expression, accessibility and community development.

  The Fringe encourages artists to explore and test boundaries and make bold choices in the creation of art.}
  i.address = "2 Daly Ave, Ottawa, ON"
  i.url = 'http://www.ottawafringe.com'
  i.begin_at = 4.days.from_now
  i.end_at = 4.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "TD Canada Trust Ottawa International Jazz Festival "
  i.description = %Q{The TD Canada Trust Ottawa International Jazz Festival is one of the National Capital Region's premiere music events. It features the finest jazz musicians from Canada and around the world performing in open air venues and intimate studio spaces where thousands can enjoy world class music. 
  }
  i.address = "40 Elgin St, Ottawa, ON"
  i.url = 'http://www.ottawajazzfestival.com '
  i.begin_at = 5.days.from_now
  i.end_at = 5.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "review"
  i.title = "Sir John A Pub"
  i.description = %Q{We crawled Elgin St looking for a pub that wasn't full to a fire hazard to watch the Stanley Cup finals. We managed to grab one of the few remaining free tables way in the back. For drinks, my gf got a Long Island and I kept it simple with a gingerale (or was it lemonade?). We also got a nacho platter that we weren't able to finish, given the generous amounts of salt that went into whatever cheese they used. It would also have helped for the cheese to not come off in basically one large chunk, leaving a whole layer of chips beneath it. That being said, it was the Stanley Cup Finals and the wait staff were clearly on the edge and scrambling to make sure everybody was being looked after. The manager came over to us a few times just to double-check, which was very much appreciated.}
  i.address = "284 Elgin Street, Ottawa, ON"
  i.url = ''
  i.begin_at = 4.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "review"
  i.title = "Pookie's Thai Restaurant"
  i.description = %Q{The gf and I are continuing our noble quest to have pad thai at every Thai restaurant in the city (fast food outlets not included) and Pookie's has earned a spot on our podium.

  The décor is pleasant, the music varied and non-intrusive, the table set-up cute and the wall decorations a nice touch. The gf's only concern was the lighting, which was a bit on the strong side.

  We started with what were called pork spring rolls. I say this because, while the ingredients were all of what is expected, the presentation was a plus as it came to us in what looked like hobbit gold bags from LoTR. The lemongrass tea, another standard in our comparative exercise, was potent though perhaps a bit too strong.

  Our mains were a curry chicken dish (stew?) and of course, the requisite pad thai with a side of sticky rice. Put together, the curry and rice helped find an appropriate level of spiciness. The chicken itself was a little dry, but otherwise enjoyable.

  The pad thai came with scallops and shrimp. The peanut sauce was done just right. The salt, tang and sweet flavours with the tamarind backdrop all blended together in a well-thought out balance, the taste itself fleeting quickly away. The only thing missing was a lime.

  After the meal, we took a minute to read the Citizen's review and chatted it up with the manager, who was very interested in what we had to say. (The family behind us made no secret of listening in on the conversation. Meh.) She asked us to compare her dishes against that of other Thai restaurants, so we started listing off a few, as well as talking about our "quest". She was quick to point out how many Thai restaurants are already open and running, which restaurants have Thai in the name but shouldn't be considered as such (no names here, obviously) and where potential sites are for more opening restaurants. She clearly knew her stuff.

  All in all, good food, good service, but the one factor that's really killing this restaurant is the location. If you're traveling west on Carling, you can barely make out the signs and even if you do, you have a-ways to go before you can switch lanes/U-turn because the lanes are divided. If you're headed east, you had better have your eyes peeled. It's well worth the find.}
  i.address = "2280 Unit 7 Carling Ave, Ottawa, ON"
  i.url = ''
  i.begin_at = 7.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "review"
  i.title = "Divino Wine Studio"
  i.description = %Q{I hav been to divio before and thought it was fantastic. But this time around was terrible. We were ther maybe 2 weeks ago. I was wondering if the chef was on vacation or something because it was a different person. The menu got smaller which was fine but some of my favs were not on there any more.The food that was on the menu was a bit boring. I had the scallop dish and my friend had the pasta with the meat sauce. My scallops were very overcooked and her pasta was bland and over done. The chef's specials were not overly exciting. But on a good note, the service was great. We felt very pampered and well looked after. I think we will wait a couple of weeks and then try again. Maybe the chef will be back by then.}
  i.address = "225 Preston St, Ottawa, ON"
  i.url = ''
  i.begin_at = 4.days.from_now
end

discussion = Item.seed(:title) do |i|
  i.kind = "discussion"
  i.title = "Traffic sucks!"
  i.description = %Q{}
  i.address = "400 lees ave, Ottawa, ON"
  i.url = ''
  i.begin_at = 10.minutes.ago
end
discussion.conversations << Conversation.new(:message => "No idea what's happening, I just want to get home!", :author => 'Sam Body', :email => 'sam@example.com', :posted_at => 10.minutes.ago)
discussion.conversations << Conversation.new(:message => "Yeah, I think there's a crash somewhere.", :author => 'Anne Onamus', :email => 'info@collectiveidea.com', :posted_at => 7.minutes.ago)
discussion.conversations << Conversation.new(:message => "Maybe, but I don't see it.", :author => 'Sam Body', :email => 'sam@example.com', :posted_at => 2.minutes.ago)
discussion.save

# Item.seed(:title) do |i|
#   i.kind = ""
#   i.title = ""
#   i.description = %Q{}
#   i.address = ""
#   i.url = ''
#   i.begin_at = Date.parse('2009-06-18')
# end