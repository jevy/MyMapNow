class Graticule::Geocoder::Canned
  class_inheritable_accessor :responses
  self.responses = []
  class_inheritable_accessor :default
  
  def locate(address)
    responses.shift || default
  end
end