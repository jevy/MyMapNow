class Item < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :begin_at

  # FIXME: this is ugly; we really require either lat/lng or address
  validates_presence_of :latitude, :unless => :address_provided?
  validates_presence_of :longitude, :unless => :address_provided?
  validates_presence_of :address, :unless => :latitude_and_longitude_provided?

  after_create :geocode_address

  def self.find_in_bounds(southwest, northeast, begin_at, end_at)
    find(:all, :conditions => ["latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?", southwest[0], southwest[1], northeast[0], northeast[1]])
  end

  def geocode_address
    return unless latitude.nil? or longitude.nil?
    location = Geocoder.locate(address)
    self.update_attributes(:latitude => location.latitude, :longitude => location.longitude)
  end

  def address_provided?
    !address.blank?
  end

  def latitude_and_longitude_provided?
    !(latitude.nil? and longitude.nil?)
  end
end
