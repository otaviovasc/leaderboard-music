class ArtistsController < ApplicationController
  before_action :authenticate_user!

  def show
    @artist = Artist.find_by(spotify_id: params[:id])
    if @artist
      @leaderboard = Rails.cache.fetch("artist_leaderboard/#{@artist.id}", expires_in: 1.hour) do
        ArtistStat.where(artist: @artist).order(listening_time: :desc).includes(:user).to_a
      end
    else
      redirect_to profile_path, alert: 'Artist not found.'
    end
  end
end
