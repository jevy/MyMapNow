require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe LastfmRequest do
  context "when extracting the start date/time" do
    it "should work with EST time zone" do
      xml = Nokogiri::XML <<-EOXML
      <event>
        <venue>
          <location>
            <timezone>EST</timezone>
          </location>
        </venue>
        <startDate>Mon, 30 Jun 2008</startDate>
        <startTime>20:00</startTime>
      </event>
      EOXML
      time = LastfmRequest.extract_start_time(xml)
      time.utc.should eql Time.gm(2008,7,1,01,00,00) # in UTC
    end

    it "should work with PST time zone" do
      xml = Nokogiri::XML <<-EOXML
      <event>
        <venue>
          <location>
            <timezone>PST</timezone>
          </location>
        </venue>
        <startDate>Mon, 30 Jun 2008</startDate>
        <startTime>20:00</startTime>
      </event>
      EOXML
      time = LastfmRequest.extract_start_time(xml)
      time.utc.should eql Time.gm(2008,7,1,04,00,00) # in UTC
    end

    it "should work with no timezone"
  end

  it "should assume a length of 3 hours" do
    xml = Nokogiri::XML <<-EOXML
    <event>
      <venue>
        <location>
          <timezone>PST</timezone>
        </location>
      </venue>
      <startDate>Mon, 30 Jun 2008</startDate>
      <startTime>20:00</startTime>
    </event>
    EOXML
    start_time = LastfmRequest.extract_start_time(xml)
    end_time   = LastfmRequest.generate_end_time(xml)
    (start_time + 3.hours).should eql end_time
  end
end
