class Item
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :description, String
  key :begin_at, Time
  key :end_at, Time
  key :url, String
  key :address, String
  key :latitude, Float
  key :longitude, Float
  key :kind, String
  
  before_save :attach_geocode
  
  def self.find_in_bounds(southwest, northeast, begin_at, end_at)
    find :all, :conditions => {
      :latitude =>  {'$gte' => southwest[0].to_f, '$lte' => northeast[0].to_f},
      :longitude => {'$gte' => southwest[1].to_f, '$lte' => northeast[1].to_f},
      :begin_at => {'$gte' => begin_at.beginning_of_day, '$lte' => end_at.end_of_day}
    }
  end
  
  def body
    length = 100
    description.blank? || description.length <= length ? description : description[0..length] + '…'
  end
  
  def attach_geocode
    unless address.blank?
      location = Geocode.geocoder.locate(address)
      self.latitude = location.latitude
      self.longitude = location.longitude
    end
  end
end
