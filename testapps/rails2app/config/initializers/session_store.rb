# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails2app_session',
  :secret      => 'b58aa1b78eba02533f6a6d353e0fb8f60c639a9d235a8afb1f02c2857128492c9a225b4b3f789fc972e3f43c768f664974a5130ed8cb91b7b106254290d3f5a0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
