class Item < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :begin_at
  validates_presence_of :latitude
  validates_presence_of :longitude
end
