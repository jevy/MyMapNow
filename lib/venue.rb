class Venue
  attr_accessor :name, :city, :state, :address,
    :latitude, :longitude

  def full_address
    return "" if (!address or !city or !state)
    address + ', ' + city + ', ' + state
  end

  def coordinates
    geocoder = Graticule.service(:google).new "ABQIAAAAFRf0kHHTAwfnYFoh1eZH6BRi_QCTkdRWobLL_A5W6S7qSSFeQRRqJG7tcFKh_yySJlsACF58wUTsLg"
    location = geocoder.locate full_address
    return location.coordinates
  end
end
