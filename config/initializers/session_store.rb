# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_enspiral_session',
  :secret      => 'cf2777bf439b74c5a9e63cc722a9967c66b90c2df4afb37cb2ca4be3ede4a7519d303d4cd38999517673d9c058196d279ebe520d08770f58ea7965d06a673855'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
