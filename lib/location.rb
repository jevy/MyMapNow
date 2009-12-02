class Location
  attr_accessor :city, :region, :country

  def initialize(city, region, country)
    @city = city
    @region = region
    @country = country
  end

end

