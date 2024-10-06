class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @top_artists = fetch_user_top_artists
  end

  private

  def fetch_user_top_artists
    response = HTTParty.get(
      'https://api.spotify.com/v1/me/top/artists',
      headers: { 'Authorization' => "Bearer #{current_user.access_token}" }
    )
    artists = response.parsed_response['items']
    artists.each do |artist_data|
      artist = Artist.find_or_create_by(spotify_id: artist_data['id']) do |a|
        a.name = artist_data['name']
        a.image_url = artist_data['images'].first['url'] if artist_data['images'].any?
      end
      ArtistStat.find_or_create_by(user: current_user, artist: artist) do |stat|
        stat.listening_time = rand(1000) # Placeholder for actual listening time
        stat.updated_at = Time.now
      end
    end
    artists
  end
end
