class Conversation
  include MongoMapper::EmbeddedDocument
  
  key :message, String, :required => true
  key :author, String, :required => true
  key :email, String
  key :posted_at, Time

  include Gravtastic
  is_gravtastic!  
  
  def to_json(options)
    super options.merge(:methods => :gravatar_url, :except => :email)
  end
end
