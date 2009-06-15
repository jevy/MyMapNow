class Item
  include MongoMapper::Document
  
  key :title, String

  # TODO: move into MongoMapper
  include ActiveRecord::Serialization
  alias_method :attribute_names, :defined_key_names
  public :attribute_names
  def self.inheritance_column; false; end
end
