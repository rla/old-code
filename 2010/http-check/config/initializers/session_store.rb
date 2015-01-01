# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_requirements_session',
  :secret      => '0081eb72a10f85c2a33c6294b2bc9c4813abe7bafafb800099114c6d1b06cf40691a3445cc0cd730e01143e323fb9b80381e5f40aa0c1698c30ee147d4609742'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
