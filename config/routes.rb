Rails.application.routes.draw do
  root 'home#index'

  # The OmniAuth callback route for Spotify
  get '/auth/:provider/callback', to: 'sessions#create'

  # Login and Logout routes
  get '/login', to: redirect('/auth/spotify')
  delete '/logout', to: 'sessions#destroy'

  # User routes
  get '/profile', to: 'profiles#show'
  get '/artist/:id', to: 'artists#show', as: 'artist'

  # Handle OAuth failures
  get '/auth/failure', to: 'sessions#failure'
end
