class Item < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :begin_at
  
  # FIXME: this is ugly; we really require either lat/lng or address
  validates_presence_of :latitude, :unless => :address_provided?
  validates_presence_of :longitude, :unless => :address_provided?
  validates_presence_of :address, :unless => :latitude_and_longitude_provided?
  
  def address_provided?
    !address.blank?
  end
  
  def latitude_and_longitude_provided?
    !(latitude.nil? and longitude.nil?)
  end
end
