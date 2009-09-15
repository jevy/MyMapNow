require 'item'

class Item
  def self.seed(*constraints, &block)
    SeedFu::Seeder.plant(self, *constraints, &block)
  end
end


Item.seed(:title) do |i|
  i.kind = 'news'
  i.title = "Flight to Ottawa delayed by drunken fracas"
  i.description = %Q{"An Air Canada flight from Saskatoon to Ottawa was delayed Wednesday morning so police could deal with a group of drunken passengers, two of whom started fighting.

The incident took place around 8 a.m. CT, prior to takeoff. According to the airline's website, a regularly scheduled flight from Saskatoon to Ottawa, operated by the company's regional carrier Jazz, was delayed by about 35 minutes."}
  i.address = "MacDonald-Cartier International Airport, Ottawa, ON"
  i.url = 'http://www.cbc.ca/canada/ottawa/story/2009/08/19/sask-air-canada-disturbance-flight.html'
  i.begin_at = 1.days.ago #Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.kind = 'event'
  i.title = "Ceremony to mark 1989 fatal gay-bashing"
  i.description = %Q{"A unique ceremony will he held in Ottawa to honour the memory of a man who was murdered on Aug. 21, 1989, because his attackers thought he was gay.

Alain Brosseau — a 33-year-old man on his way home from a late shift at the Chateau Laurier Hotel — was attacked by a group of men and dropped from the Alexandra Bridge. He was not, in fact, gay.

On Friday, Ottawa police will join the gay, lesbian, bisexual and transgender community to honour Brosseau.

Ottawa Police Chief Vern White and his Gatineau counterpart Mario Harel will march along the Alexandra Bridge and meet in the middle for a symbolic exchange."}
  i.address = "Alexandra Bridge, Ottawa, Ontario"
  i.url = 'http://www.cbc.ca/canada/ottawa/story/2009/08/19/ottawa-brosseau-memorial-ceremony.html'
  i.begin_at = 2.days.from_now #Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.kind = 'news'
  i.title = "Ottawa's Diefenbunker readies for the masses"
  i.description = %Q{"Ottawa's underground Cold War museum will be able to accommodate hundreds more visitors at once following an upgrade set to begin this fall.

All three levels of government have now committed $1.2 million toward the Diefenbunker's $1.5-million infrastructure project, including provincial money announced earlier in August.

The facility, now designated as a National Historic Site, was commissioned under then prime minister John Diefenbaker and built between 1959 and 1961 in the village of Carp as a secret shelter for Canadian government leaders in case of a nuclear attack. The bunker's four storeys are buried under a grassy hill in what is now part of Ottawa's western outskirts.

Even though the building was designed to house 500 people for 30 days, only 60 visitors are currently allowed inside at one time and only while led by a tour guide because the facility doesn't meet building code regulations."}
  i.address = "3911 Carp Road, Carp, ON"
  i.url = 'http://www.cbc.ca/canada/ottawa/story/2009/08/18/ottawa-090818-diefenbunker-renovation-upgrade.html'
  i.begin_at = 2.days.ago #Date.parse('2009-06-18')
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "Ottawa woman dragged by car"
  i.description = %Q{"An Ottawa woman was in a coma in hospital Tuesday after being dragged by a sports car during an apparent robbery the night before.

  A witness saw the 31-year-old woman struck and dragged by the vehicle around 9 p.m. Monday on Plainhill Drive, a newer residential street in Ottawa's far east end, Staff Sgt. Don Sweet of the Ottawa Police robbery unit said Tuesday.

  A white or silver sports car was seen speeding from the scene, and its front end or windshield may have been damaged, Sweet added.

  Police believe the woman had advertised an item of jewelry for sale on the internet and was contacted by someone who made arrangements to buy it. She apparently went outside her home and an altercation ensued, Sweet said."}
  i.address = "Plainhill Drive, Ottawa, ON"
  i.url = 'http://www.cbc.ca/canada/ottawa/story/2009/08/18/ottawa-dragged-car-plainhill.html'
  i.begin_at = 2.days.ago
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "Baby OK after being found in hot Ont. car"
  i.description = %Q{"An infant reportedly left alone in a hot, unlocked car in Rockland, Ont., at lunchtime Monday as the temperature soared to about 30 C has been located and is doing fine, police said Tuesday morning.

"We spoke with the mother, and the officers that attended checked out the child and it was OK," said Ontario Provincial Police Const. Guy Prevost. Police said the baby girl was three or four months old.

The OPP and the Children's Aid Society are continuing to investigate the incident on Laurier Street in the town, which is about 40 kilometres east of Ottawa.

OPP Const. Bernard Montpetit said the mother of the child was very emotional Tuesday morning, and it was "not a good time" for police to get a statement from her. They would get involved further if the Children's Aid Society requests that they do so, he added.

So far, charges of negligence or abandonment are unlikely, Montpetit said."}
  i.address = "Jean Coutu, Rockland, Ontario"
  i.url = 'http://www.cbc.ca/canada/ottawa/story/2009/08/18/rockland-baby-hot-car.html'
  i.begin_at = 3.days.ago
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "325 flee Ontario train fire"
  i.description = %Q{"Hundreds of Via Rail passengers fled a train on Ottawa's southwest outskirts after it caught fire Sunday night.

The fire broke out in the engine of Train 46 from Toronto at about 8:15 p.m. ET. The Ottawa-bound train was about three kilometres from the level crossing at McBean Street, just south of the town of Richmond, which is now part of Ottawa, Via Rail reported.

The train had left Toronto at 3:35 p.m. and was scheduled to arrive at the Ottawa train station at 8:11 p.m.

No one was seriously hurt, but the two crew members suffered from smoke inhalation and the 323 passengers were forced to stand and wait for more than an hour before they could board air-conditioned Ottawa transit buses.

"It was a very remote area and very swampy," said sector fire Chief Gerry Pingitore. "There was no light and the mosquitoes were terrible."

The cause of the blaze was still under investigation Monday.

Heather Avon, who was on the train with her son Andrew, said lights started flickering in the cabin just past Smiths Falls. Then she smelled burning rubber."}
  i.address = "McBeen Street, Richmond, Ontario"
  i.url = 'http://www.cbc.ca/canada/ottawa/story/2009/08/17/ottawa-train-fire-via-rail-richmond-smiths-falls.html'
  i.begin_at = 1.days.ago
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "Ottawa memorial marks soldiers' Hong Kong sacrifice"
  i.description = %Q{A monument honouring Canada's veterans of the Battle of Hong Kong was formally unveiled in Ottawa on Saturday.

The granite-sheathed memorial bears the names of some 2,000 men who fought for 17 days against a massive Japanese invasion of the then-British colony; survivors were held as prisoners of war from 1941 until 1945.

Saturday's unveiling took place on the 64th anniversary of VJ-Day, the end of the Pacific campaign of the Second World War.

"Their sacrifice has made a difference," Padre Alain Monpas told the assembled crowd of veterans, soldiers, families, friends and dignitaries.

"We're here today because we have a solemn responsibility to remember," Veterans Affairs Greg Thompson said.

The soldiers being remembered had been sent in the autumn of 1941 to bolster the defences of Hong Kong against a possible Japanese attack.

Only about 90 of the men are still alive. A handful were able to attend the dedication. They were part of C Force — the Royal Rifles of Canada, the Winnipeg Grenadiers and a brigade headquarters — which arrived in Hong Kong on Nov. 16, 1941.

Three weeks later, with the Canadians barely acclimated, Japanese forces attacked the then-British colony in overwhelming force. Its defence was a hopeless cause from the start.

Without air cover, lacking heavy weapons and transport, the men of C Force fought on fiercely, before surrendering on Christmas Day. During the bitter fighting, 290 Canadians were killed and 483 wounded.
Endured malnourishment, mistreatment

But that was just the beginning of an ordeal that would drag on until August 1945.

The Canadians endured brutal conditions as prisoners of the Japanese. Many were beaten or tortured. Food allowances dropped to as low as 800 calories a day for men forced into slave labour in mines or at dockyards.

"They clung to their faith that they would survive," Thompson told the crowd. "They struggled to make it though another day," he said.}
  i.address = "King Edward and Sussex, Ottawa, ON"
  i.url = ''
  i.begin_at = 2.days.ago
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "19th-century Ottawa convent for sale"
  i.description = %Q{A century-old cloistered convent in Ottawa's Westboro neighbourhood has been put up for auction as the City of Ottawa scrambles to protect it with a heritage designation.

"It would be a travesty to lose something like this," said Christine Leadman, city councillor for Kitchissippi Ward where Les Soeurs de la Visitation convent is located, in an interview Friday.}
  i.address = "114 Richmond Rd, Ottawa, ON"
  i.url = ''
  i.begin_at = 3.days.ago
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "Chelsea-Wakefield highway funding confirmed"
  i.description = %Q{Highway 5 will be extended between the Quebec towns of Chelsea and Wakefield, the federal and provincial governments confirmed Friday.

Both governments will share the $115-million cost of the 6.5-kilometre extension from Meech Creek in Chelsea to the Wakefield bypass at the La Pêche River, Premier Jean Charest announced alongside Prime Minister Stephen Harper at a news conference in Chelsea on Friday.

Work will begin in early 2010 and will be completed by 2012, Charest added.}
  i.address = "Wakefield, Quebec"
  i.url = ''
  i.begin_at = 3.days.ago
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "Gatineau beach closed over blue-green algae"
  i.description = %Q{

A beach at Gatineau Park's Meech Lake has been closed after a bloom of blue-green algae was found near the edge of the beach, the National Capital Commission said Friday afternoon.

Blue-green algae, also known as "pond scum," can range in colour from olive-green to red and produce toxins that can cause health risks to both humans and animals.

O'Brien Beach was closed after the bloom of cynobacteria was reported for health and safety reasons, the NCC said in a media release.

Blanchet Beach at Meech Lake and the beaches at lakes Philippe and La Pêche are still open to swimmers.  }
  i.address = "Meech Lake, Gatineau, Quebec"
  i.url = ''
  i.begin_at = 1.days.ago
end

Item.seed(:title) do |i|
  i.kind = "news"
  i.title = "Ottawa crash blamed on street race"
  i.description = %Q{
Street racing is being blamed for an Ottawa collision that mangled a Honda Civic, shattered a bus shelter and sent chunks of a concrete wall flying into a gazebo and house.

A 17-year-old male has been charged with dangerous driving after the crash on Jeanne d'Arc Boulevard near Orléans Boulevard just before 4:30 p.m. Thursday, which caused up to $75,000 damage, said Ottawa police Sgt. Rick Giroux Thursday.

Const. Alain Boucher said Friday afternoon that the teen is expected to face additional charges. The driver of the Mazda, in his 20s, has been located by police and is expected to be charged next week, he added.

The 17-year-old, who cannot be named under the Youth Criminal Justice Act, was not hurt in the collision, but a 16-year-old girl riding in the car with him was sent to hospital with a sore neck and back.}
  i.address = "Jeanne d'arc and Orleans Boulevand, Ottawa, Ontario"
  i.url = ''
  i.begin_at = 1.days.ago
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Health & Wellness Lunch and Learn - 10 Tips to Maintain a Healthy Heart"
  i.description = %Q{
Revera Retirement is delighted to be working with Pfizer Canada for our Health & Wellness lunch & Learn Series, to bring local seniors exceptional guest speakers on various topics through the summer. Join us for a complimentary informational presentation on 10 Tips to Maintain a Healthy Heart on August 19th from 11-1pm at Coloenl By Retirement Residence 43 Aylmer Ave RSVP by calling 613-730-2002 Presentation followed by complimentary a "Heart Smart" luncheon.  }
  i.address = "43 Aylmer Ave, Ottawa, Canada"
  i.url = ''
  i.begin_at = 1.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Cool Reads for Warm Days"
  i.description = %Q{Lazy, hazy days are perfect for cool reads! Join us for tea, or iced tea, and get suggestions for great summer reading. Alta Vista Branch, Ottawa Public Library, 2516 Alta Vista Drive. 10:30 a.m. (1 hour) Theme: Gentle Reads (Heart-warming stories). Please call: 613-737-2837 x28 }
  i.address = "2516 Alta Vista Drive, Ottawa, Canada"
  i.url = ''
  i.begin_at = 1.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Bug Hunt at Billings Estate"
  i.description = %Q{ Kids will learn to identify different types of insects, where to find them and why they’re important to the natural world in this program at Billings Estate National Historic Site. Every Thursday and Sunday in August, starting August 6. 2 p.m. - 4 p.m. Cost: $6/child. 2100 Cabot St. Ottawa K1H 6K1 613 247 4830 }
  i.address = "2100 Cabot St., Ottawa, Ontario"
  i.url = 'http://www.ottawa.ca/museums'
  i.begin_at = 1.days.ago
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "One Change: Fuel campaign launch at SuperEX!"  
  i.description = %Q{
The One Change: Fuel team is excited to launch our Ottawa pilot campaign on opening day at the SuperEX! One Change: Fuel, along with campaign sponsors—Natural Resources Canada, The Ontario Trillium Foundation, and Canadian Tire— will be on hand to kick-off this unique fuel-efficiency pilot project. The event will include the distribution of 1,000 free digital tire gauges, refreshments and valuable fuel- and money-saving information. This exciting event will be emceed by Bill Welychka, Weather Anchor for the “A” Morning show. Entry into the SuperEX is free from 12-5pm. For more information please see our media release at http://www.onechange.org/fuel/weblog/media-advisory-launch/ or contact Corrie at corrie@onechange.org. To volunteer for this event or for other One Change: Fuel efforts please visit http://www.onechange.org/fuel/volunteer/.  }
  i.address = "Lansdowne Park, Ottawa, ON"
  i.url = 'http://www.onechange.org/fuel/events/'
  i.begin_at = 2.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Ottawa Folk Festival"
  i.description = %Q{The Ottawa Folk Festival is held in the middle of August in beautiful Britannia Park in Ottawa's west end. The Festival has been recognized as one of the "Top 50 Ontario Festivals" by Festival & Events Ontario. Our 2009 festival will be held from Friday August 21st to Sunday August 23rd. The Ottawa Folk Festival features a beautiful Main Stage, 7 simultaneous daytime stages, vendors offering handmade crafts, instruments and top quality fair trade products, a food court with mouth-watering ethnic and festive foods, and jaw-dropping sunsets. And some great music!  }
  i.address = "Britannia Park, Ottawa, Canada"
  i.url = 'http://www.ottawafolk.org'
  i.begin_at = 3.days.from_now
  i.end_at = 5.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Ottawa Reggae Festival"
  i.description = %Q{ The Ottawa Reggae Festival is a three-day music festival in downtown Ottawa at Lebreton Flats Park. The festival showcases live performances from some of Canada's best musical artists and from international artists.  }
  i.address = "Lebreton Flats Park, Ottawa, Canada"
  i.url = 'http://www.ottawareggaefestival.com/'
  i.begin_at = 4.days.from_now
  i.end_at = 6.days.from_now
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Campfire & Storytelling at Billings Estate"
  i.description = %Q{ Gather around a campfire to enjoy marshmallows, songs and stories told by the Ottawa Storytellers at Billings Estate National Historic Site. Every Friday in August, starting August 7. 7 p.m. – 8:30 p.m. Cost: $10/family. 2100 Cabot St. Ottawa K1H 6K1 613 247 4830  }
  i.address = "2100 Cabot St. Ottawa, Ontario"
  i.url = 'http://www.ottawa.ca/museums'
  i.begin_at = 4.days.ago
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Crossword Author Will Sign Books at Chapters Kanata"
  i.description = %Q{ Cross-Canada Crosswords 5 author, Gwen Sjogren, will be signing her book at the Chapters Kanata from 1-4pm. Born and raised in Ontario, she is the author of the four previous Cross-Canada volumes and has been designing crosswords since her twenties.  }
  i.address = "Chapters Kanata, Ottawa, Canada"
  i.url = 'http://www.harbourpublishing.com/'
  i.begin_at = 1.days.ago
end

Item.seed(:title) do |i|
  i.kind = "event"
  i.title = "Campfire and Storytelling at Pinhey's Poin"
  i.description = %Q{Roast hotdogs and marshmallows as you gather around a crackling campfire and listen to stories on the beautiful shore of the Ottawa River. Thematic stories will include summer vacation and more. Saturday, August 22 from 6 to 7:30 pm at Pinhey’s Point Historic Site. Cost is $6 per person; $10 for two or $15 per family (max 2 adults). Children under 5 get in for free. For more information call 613-832-4347 or visit ottawa.ca/museums.   }
  i.address = "Pinhey's Point Historic Site, Ottawa, Canada"
  i.url = 'http://ottawa.ca/museums'
  i.begin_at = 1.days.from_now
end
