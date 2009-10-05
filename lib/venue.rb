class Venue
  attr_accessor :name, :city, :state, :address,
    :latitude, :longitude

  Api_code =  "ABQIAAAAFRf0kHHTAwfnYFoh1eZH6BRi_QCTkdRWobLL_A5W6S7qSSFeQRRqJG7tcFKh_yySJlsACF58wUTsLg"

  def full_address
    return "" if (!address or !city or !state)
    address + ', ' + city + ', ' + state
  end

  def coordinates
    geocoder = Graticule.service(:google).new Api_code
    location = geocoder.locate full_address
    return nil if location.precision <= Graticule::Geocoder::Google::PRECISION.index(:zip)
    return location.coordinates
  end

end
