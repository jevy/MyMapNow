# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_localmaps_session',
  :secret      => '4181ea6a6da8cb73d579ac7d542f5cf9d89472281b05995cb15d587172e8b24e25fc2527057ecf1a768cde841e70ba733b4fad59db89d3583128d00f598eb2dd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
