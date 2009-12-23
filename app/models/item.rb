require 'levenshtein'

class Item < ActiveRecord::Base
  ACCEPTABLE_TITLE_DISTANCE = 3
  validates_presence_of :title
  validates_presence_of :begin_at
  validate :end_at_is_after_begin_at

  # FIXME: this is ugly; we really require either lat/lng or address
  validates_presence_of :latitude, :unless => :address_provided?
  validates_presence_of :longitude, :unless => :address_provided?
  validates_presence_of :address, :unless => :latitude_and_longitude_provided?

  validate :title, :unique_item_title

  # after_create :geocode_address

  # acts_as_taggable_on :tags

  def self.find_in_bounds(southwest, northeast, begin_at, end_at)
    find(:all, :conditions => ["latitude BETWEEN ? AND ? " + 
          "AND longitude BETWEEN ? AND ? " +
          "AND ((begin_at BETWEEN ? AND ?) " +
          "     OR (begin_at < ? AND end_at BETWEEN ? AND ?) " +
          "     OR (begin_at < ? AND end_at > ?)) ",
        southwest[0], northeast[0],
        southwest[1], northeast[1],
        begin_at.to_s(:db), end_at.to_s(:db),
        begin_at.to_s(:db), begin_at.to_s(:db), end_at.to_s(:db),
        begin_at.to_s(:db), end_at.to_s(:db)],
      :order => 'begin_at')
  end

  def self.find_in_time_range(hour_range, start_time)
    Item.find(:all, :conditions=>["begin_at BETWEEN ? AND ?",
        start_time.advance(:hours=>-hour_range),
        start_time.advance(:hours=>hour_range)])
  end

  def self.group_by_date(items)
    result ={}
    items.each do |item|
      date = item.begin_at.to_date
      result[date] ? result[date] << item : result[date] = [item]
    end
    result
  end

  def geocode_address
    return unless latitude.nil? or longitude.nil?
    location = Geocoder.locate(address)
    self.update_attributes(:latitude => location.latitude, :longitude => location.longitude)
  end

  def end_at_is_after_begin_at
    return unless end_at
    errors.add(:end_at, 'Cannot be before begin_at') if end_at < begin_at
  end

  def address_provided?
    !address.blank?
  end

  def latitude_and_longitude_provided?
    !(latitude.nil? and longitude.nil?)
  end

  def duplicate?(comparison)
    return false if self.eql?(comparison)
    distance = Levenshtein.distance(comparison.title.simplify, self.title.simplify)
    distance < ACCEPTABLE_TITLE_DISTANCE
  end

  def unique_item_title
    return unless begin_at
    Item.find_in_time_range(2, begin_at).each do |event|
      if duplicate?(event)
        errors.add(:title,"Duplicate event title.")
        break
      end
    end
  end
  
end

class String
  def simplify
    self.downcase.gsub(' ','')
  end
end