class ConvertDateKey < ActiveRecord::Migration
  
  class Item
    include MongoMapper::Document

    key :date, Time
    key :begin_at, Time

    key :title, String, :required => true
    key :description, String
    key :url, String
    key :address, String
    key :latitude, Float
    key :longitude, Float
  end
  
  def self.up
    ConvertDateKey::Item.find(:all).each do |item|
      item.begin_at = item.date
      item.date = nil
      item.save!
    end
  end

  def self.down
    ConvertDateKey::Item.find(:all).each do |item|
      item.date = item.begin_at
      item.begin_at = nil
      item.save!
    end
  end
end
