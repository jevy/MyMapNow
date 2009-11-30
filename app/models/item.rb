require 'levenshtein'

class Item < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :begin_at
  validate :end_at_is_after_begin_at

  # FIXME: this is ugly; we really require either lat/lng or address
  validates_presence_of :latitude, :unless => :address_provided?
  validates_presence_of :longitude, :unless => :address_provided?
  validates_presence_of :address, :unless => :latitude_and_longitude_provided?

  validates_uniqueness_of :title, :allow_nil=>true, :allow_blank=>true,
    :case_sensitive=>false, 
    :if=>:matches_other_item

  after_create :geocode_address
  belongs_to :user

  #  acts_as_taggable_on :tags

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

  def matches_other_item
    return true if self.title.nil? #Bah! Feels hackish, config wouldn't handle nil
    current_item_simplified = self.title.downcase.gsub(' ','')
    puts "string 1 #{current_item_simplified}"
    Item.find(:all).each do |current_item|
      comp_string_comparison = current_item.title.downcase.gsub(' ','')
      puts "string 2 #{comp_string_comparison}"
      puts "distance #{Levenshtein.distance(comp_string_comparison,current_item_simplified )}"
      return true if (Levenshtein.distance(comp_string_comparison,current_item_simplified ) < 3)
    end
    false
  end
  
end
