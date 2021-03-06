# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

# require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

require File.dirname(__FILE__) + '/geocoder'
Geocoder = Graticule::Geocoder::Canned.new

LOCATIONS = {
  'Ottawa' => Graticule::Location.new(
    :locality => "Ottawa",
    :region => "ON",
    :country => "Canada",
    :precision => :locality,
    :latitude => 45.420833,
    :longitude => -75.69
  ), 
  
  'Detroit' => Graticule::Location.new(
    :locality => "Detroit",
    :region => "MI",
    :country => "USA",
    :precision => :locality,
    :latitude => 42.3316,
    :longitude => -83.0475
  )
}
Geocoder.default = LOCATIONS['Ottawa']

# Add canned responses using:
# Geocode.geocoder.responses << LOCATIONS['Ottawa']

Before do
  MongoMapper.database.collection_names.each do |name|
    MongoMapper.database.collection(name.split('.').last).clear
  end
end