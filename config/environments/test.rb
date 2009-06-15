# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

config.gem 'fakeweb'
config.gem 'cucumber', :version => '0.3.9',  :lib => false
config.gem 'webrat',   :version => '0.4.4',  :lib => false
config.gem 'Selenium', :lib => 'selenium'

config.with_options :source => 'http://gems.github.com' do |github|
  github.gem 'thoughtbot-shoulda',      :version => '2.10.1', :lib => 'shoulda'
  github.gem 'jnunemaker-matchy',       :version => '0.4.0',  :lib => 'matchy'
  github.gem 'thoughtbot-factory_girl', :version => '1.2.1',  :lib => 'factory_girl'
  github.gem 'bmabey-database_cleaner', :version => '0.2.2',  :lib => 'database_cleaner'
end
