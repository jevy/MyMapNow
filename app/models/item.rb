class Item
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :description, String
  key :date, Time
  key :url, String
  key :address, String
  key :latitude, Float
  key :longitude, Float
  
  before_save :attach_geocode
  
  def self.find_in_bounds(southwest, northeast)
    find :all, :conditions => {
      :latitude =>  {'$gte' => southwest[0].to_f, '$lte' => northeast[0].to_f},
      :longitude => {'$gte' => southwest[1].to_f, '$lte' => northeast[1].to_f},
    }
  end
  
  def body
    length = 100
    description.length > length ? description[0..length] + '…' : description
  end
  
  def attach_geocode
    unless address.blank?
      location = Geocode.geocoder.locate(address)
      self.latitude = location.latitude
      self.longitude = location.longitude
    end
  end
end
