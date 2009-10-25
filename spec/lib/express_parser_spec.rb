require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe ExpressParser do

  $valid_event_row_1 = "<tr><td>&nbsp;</td><td><a href='/music/artist.aspx?iIDGroupe=34484'>Alexandre Désilets</a></td><td>&nbsp;</td><td><nobr>Song</nobr></td><td>&nbsp;</td><td><a href='/music/venue.aspx?iIDSalle=6665'>Salle Anaïs-Allard-Rousseau</a></td><td>&nbsp;</td><td><nobr>Oct 22</nobr></td></tr>"
  $valid_event_row_2 = "<tr><td class='musiqueAlternate'>&nbsp;</td><td class='musiqueAlternate'><a href='/music/artist.aspx?iIDGroupe=8010'>Bori</a></td><td class='musiqueAlternate'>&nbsp;</td><td class='musiqueAlternate'><nobr></nobr></td><td class='musiqueAlternate'>&nbsp;</td><td class='musiqueAlternate'><a href='/music/venue.aspx?iIDSalle=2642'>Granada Theater</a></td><td class='musiqueAlternate'>&nbsp;</td><td class='musiqueAlternate'><nobr>Oct 22</nobr></td></tr>"
  $valid_artist_div = "<div id='pnlFiche'><br /><SPAN class=titreSpectacle><B>Alexandre Désilets</B></SPAN><br />&nbsp;<BR>Thursday, Oct 22, 2009<BR><A href='/music/venue.aspx?iIDSalle=6665'>Salle Anaïs-Allard-Rousseau</A><BR>1425 Hôtel-de-Ville Pl., Trois-Rivières<BR>&nbsp;<BR></div>"

  before(:each) do
    @page = `cat spec/lib/testData/xpress/music.html`
    @args = {:uri => 'http://www.ottawaxpress.ca',
      :type => 'music',
      :body => @page
    }
    @parser = create_parser(@args)
  end

  it "should parse one link from a single link page" do
    doc = Hpricot.parse("<a >Anything</a>")
    @parser.send(:doc_links, doc).length.should eql(1)
  end

  it "should not parse a single link on a doc that has none" do
    doc = Hpricot.parse("<div>Anything</div>")
    @parser.send(:doc_links, doc).length.should eql(0)
  end

  it 'should parse a single link in a div tag' do
    doc = Hpricot.parse("<div><a>Anything</a></div>")
    @parser.send(:doc_links, doc).length.should eql(1)
  end

  it "should parse all document links from the test page" do
    @parser.send(:doc_links, @doc).length.should eql(83)
  end

  it "should parse venue(IDSalle) links" do
    doc = Hpricot.parse("<tr><a href='iIDSalle'>Anything</a><a href='nothing'>Shouldn't show up.</a></tr>")
    @parser.send(:event_links, doc).length.should eql(1)
  end

  it "should parse venue(IDGroupe) links" do
    doc = Hpricot.parse("<tr><a href='iIDGroupe'>Anything</a><a href='nothing'>Shouldn't show up.</a></tr>")
    @parser.send(:event_links, doc).length.should eql(1)
  end

  it "should parse show(iIDShow) links" do
    doc = Hpricot.parse("<tr><a href='iIDShow'>Anything</a><a href='nothing'>Shouldn't show up.</a></tr>")
    @parser.send(:event_links, doc).length.should eql(1)
  end

  it "should parse 3 links one of Groupe, Salle, and Show types each" do
    doc = Hpricot.parse("<tr><a href='iIDShow'>Anything</a><a href='iIDGroupe'>Anything</a><a href='nothing'>Shouldn't show up.</a><a href='iIDSalle'>Anything</a></tr>")
    @parser.send(:event_links, doc).length.should eql(3)
  end

  it "should parse the test file" do
    events_length = @parser.send(:event_links, @doc).length
    events_length.should be_even #Two per event, artist and venue
    events_length.should eql(24)
  end

  it "should return the correct number of table cells" do
    doc = Hpricot.parse("<td></td>")
    @parser.send(:doc_cells, doc).length.should eql(1)
  end

  it "should not return any docment cells" do
    doc = Hpricot.parse("<div></div>")
    @parser.send(:doc_cells, doc).length.should eql(0)
  end

  it "should accept the test string as an event row" do
    doc = Hpricot.parse($valid_event_row_1)
    @parser.send(:is_event_row?, doc).should be_true
  end

  it "should not accept the test string as an event row with only 7 table cells" do
    doc = Hpricot.parse("<tr><td>&nbsp;</td><td><a href='/music/artist.aspx?iIDGroupe=34484'>Alexandre Désilets</a></td><td>&nbsp;</td><td><nobr>Song</nobr></td>
        <td>&nbsp;</td><td><a href='/music/venue.aspx?iIDSalle=6665'>Salle Anaïs-Allard-Rousseau</a></td>
        <td><nobr>Oct 22</nobr></td></tr>")
    @parser.send(:is_event_row?, doc).should be_false
  end

  it "should not accept the test string as an event row without a iIDGroupe url" do
    doc = Hpricot.parse($valid_event_row_1.gsub("Groupe", "Invlalid"))
    @parser.send(:is_event_row?, doc).should be_false
  end

  it "should not accept the test string as an event row without a iIDSalle url" do
    doc = Hpricot.parse($valid_event_row_1.gsub("Salle", "Invalid"))
    @parser.send(:is_event_row?, doc).should be_false
  end

  it "should not accept the test string as an event row without a iIDSalle or a iIDGroupe url" do
    doc = Hpricot.parse($valid_event_row_1.gsub("Groupe", "Invlalid").gsub("Salle", "Invalid"))
    @parser.send(:is_event_row?, doc).should be_false
  end

  it "should return the rows that match event criteria" do
    doc = Hpricot.parse($valid_event_row_1+$valid_event_row_2)
    @parser.event_rows(doc).length.should eql(2)
  end
  
  it "should return the artist information from an event row" do
    doc = Hpricot.parse($valid_event_row_1+$valid_event_row_2)
    @parser.event_rows(doc).length.should eql(2)
  end

  it "should scrape the artist information" do
    page = `cat spec/lib/testData/xpress/artist.html`
    args = {:url => 'http://www.ottawaxpress.ca/music/artist.aspx?iIDGroupe=34484',
      :body => page
    }
    register_uri(args)
    response = nil
    lambda{response = @parser.send(:event_information, args[:url])}.should_not raise_error(ArgumentError)
    response.should_not be_nil
    response.each{|item| item.should_not be_nil}
  end

  it "should build the event(item) as expected" do
    test_row = Hpricot.parse($valid_event_row_1)
    page = `cat spec/lib/testData/xpress/artist.html`
    args = {:url => 'http://www.ottawaxpress.ca/music/artist.aspx?iIDGroupe=34484',
      :body => page
    }
    register_uri(args)
    events = @parser.parse_events(test_row)
    events.length.should eql(1)
    events[0].title.should eql('Alexandre Désilets')
    events[0].address.should eql('1425 Hôtel-de-Ville Pl., Trois-Rivières')
    events[0].begin_at.should eql('Thursday, Oct 22, 2009')
  end

  def create_parser(args)
    args[:url] ||= "#{args[:uri]}/#{args[:type]}/listings.aspx"
    register_uri( args)
    @doc = Hpricot open(args[:url])
    @parser = ExpressParser.new(@doc, args[:uri])
  end

  def register_uri(args)
    FakeWeb.register_uri(:get, args[:url], args)
  end

  after(:each) do
    FakeWeb.clean_registry
  end

end

