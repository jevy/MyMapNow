class Item
  include MongoMapper::Document
  
  key :title, String
  key :description, String
  key :address, String
  key :latitude, Float
  key :longitude, Float
  
  def self.find_in_bounds(southwest, northeast)
    find :all, :conditions => {
      :latitude =>  {'$gte' => southwest[0].to_f, '$lte' => northeast[0].to_f},
      :longitude => {'$gte' => southwest[1].to_f, '$lte' => northeast[1].to_f},
    }
  end
end
