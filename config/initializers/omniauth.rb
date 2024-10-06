# config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify,
           ENV['SPOTIFY_CLIENT_ID'],
           ENV['SPOTIFY_CLIENT_SECRET'],
           scope: 'user-read-email user-top-read user-read-recently-played user-read-playback-position'
          #  redirect_uri: 'http://127.0.0.1:3000/auth/spotify/callback' # or 'http://localhost:3000/auth/spotify/callback'
end


# OmniAuth.config.allowed_request_methods = %i[post get]
