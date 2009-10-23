require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe ExpressParser do

  before(:each) do
    FakeWeb.clean_registry
    @page = `cat spec/lib/testData/xpress/music.html`
    @args = {:uri => 'http://www.ottawaxpress.ca',
      :type => 'music',
      :body => @page
    }
    @parser = create_parser(@args)
  end

  it "should parse one link from a single link page" do
    doc = Hpricot.parse("<a >Anything</a>")
    @parser.send(:page_links, doc).length.should eql(1)
  end

  it "should not parse a single link on a doc that has none" do
    doc = Hpricot.parse("<div>Anything</div>")
    @parser.send(:page_links, doc).length.should eql(0)
  end

  it 'should parse a single link in a div tag' do
    doc = Hpricot.parse("<div><a>Anything</a></div>")
    @parser.send(:page_links, doc).length.should eql(1)
  end

  it "should parse all document links from the test page" do
    @parser.send(:page_links).length.should eql(83)
  end

  it "should parse venue(IDSalle) links" do
    doc = Hpricot.parse("<div><a href='iIDSalle'>Anything</a><a href='nothing'>Shouldn't show up.</a></div>")
    @parser.send(:event_links, doc).length.should eql(1)
  end

  it "should parse venue(IDGroupe) links" do
    doc = Hpricot.parse("<div><a href='iIDGroupe'>Anything</a><a href='nothing'>Shouldn't show up.</a></div>")
    @parser.send(:event_links, doc).length.should eql(1)
  end

  it "should parse show(iIDShow) links" do
    doc = Hpricot.parse("<div><a href='iIDShow'>Anything</a><a href='nothing'>Shouldn't show up.</a></div>")
    @parser.send(:event_links, doc).length.should eql(1)    
  end

  it "should parse 3 links one of Groupe, Salle, and Show types each" do
    doc = Hpricot.parse("<div><a href='iIDShow'>Anything</a><a href='iIDGroupe'>Anything</a><a href='nothing'>Shouldn't show up.</a><a href='iIDSalle'>Anything</a></div>")
    @parser.send(:event_links, doc).length.should eql(3)
  end

  it "should parse the test file" do
    events_length = @parser.send(:event_links).length
    events_length.should be_even #Two per event, artist and venue
    events_length.should eql(24)
  end
  
    
  def create_parser(args)
    FakeWeb.register_uri(:get, "#{args[:uri]}/#{args[:type]}/listings.aspx", args)
    parser = ExpressParser.new(args[:uri], args[:type])
  end

end

