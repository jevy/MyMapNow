class ConvertDateKey < ActiveRecord::Migration
  
  class Item
    include MongoMapper::Document

    key :date, Time
    key :begin_at, Time
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
