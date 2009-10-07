class Venue
  attr_accessor :name, :city, :state, :address,
    :latitude, :longitude

  Api_code =  "ABQIAAAAFRf0kHHTAwfnYFoh1eZH6BRi_QCTkdRWobLL_A5W6S7qSSFeQRRqJG7tcFKh_yySJlsACF58wUTsLg"
  @@geocoder = Graticule.service(:google).new Api_code

  def full_address
    return "" if (!address or !city or !state)
    address + ', ' + city + ', ' + state
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
