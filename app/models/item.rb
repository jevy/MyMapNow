class Item
  include MongoMapper::Document
  
  key :title, String
  key :latitude, Float
  key :longitude, Float

  # TODO: move into MongoMapper
  include ActiveRecord::Serialization
  alias_method :attribute_names, :defined_key_names
  public :attribute_names
  def self.inheritance_column; false; end
  
  def self.find_in_bounds(southwest, northeast)
    find :all, :conditions => {
      :latitude =>  {'$gte' => southwest[0].to_f, '$lte' => northeast[0].to_f},
      :longitude => {'$gte' => southwest[1].to_f, '$lte' => northeast[1].to_f},
    }
    
    # "{$where: this.latitude >= #{northeast[0]} && this.latitude <= #{southwest[0]} && this.longitude >= #{southwest[1]} && this.longitude <= #{northeast[1]}}"
  end
end
