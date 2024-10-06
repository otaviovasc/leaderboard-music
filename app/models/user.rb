class User < ApplicationRecord
  has_many :artist_stats
  has_many :artists, through: :artist_stats

  def access_token_valid?
    # Implement logic to check if the token is still valid
    # For simplicity, assume token expires in 1 hour
    (self.updated_at + 1.hour) > Time.now
  end

  def refresh_access_token
    response = HTTParty.post('https://accounts.spotify.com/api/token', body: {
      grant_type: 'refresh_token',
      refresh_token: self.refresh_token,
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      client_secret: ENV['SPOTIFY_CLIENT_SECRET']
    })
    if response.code == 200
      self.update(access_token: response.parsed_response['access_token'])
    else
      false
    end
  end

  def ensure_valid_access_token
    refresh_access_token unless access_token_valid?
  end
end
