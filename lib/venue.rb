class Venue
  attr_accessor :name, :city, :state, :address, :country,
    :latitude, :longitude

  Api_code =  "ABQIAAAAFRf0kHHTAwfnYFoh1eZH6BRi_QCTkdRWobLL_A5W6S7qSSFeQRRqJG7tcFKh_yySJlsACF58wUTsLg"
  @@geocoder = Graticule.service(:google).new Api_code

  def full_address
    result = []
    result << address  unless address.nil? or address.empty?
    result << city     unless city.nil? or city.empty?
    result << state    unless state.nil? or state.empty?
    result << country  unless country.nil? or country.empty?
    result.join(", ")
  end

  # Not sure if this is how I want to handle a bad address
  # Maybe let the exception pass through?
  def coordinates
    begin
      location = @@geocoder.locate full_address
    rescue
      return [0,0]
    end

    return location.coordinates
  end

end
