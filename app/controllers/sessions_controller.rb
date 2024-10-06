class SessionsController < ApplicationController
  def passthru
    render plain: "OmniAuth is not responding.", status: 404
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(spotify_id: auth.uid)
    user.update(
      display_name: auth.info.display_name || auth.info.name || "Spotify User",
      access_token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      profile_image_url: extract_image_url(auth.info.images)
    )
    session[:user_id] = user.id
    redirect_to profile_path
  end

  def destroy
    session[:user_id] = nil
    reset_session  # This clears the entire session, including the CSRF token
    redirect_to root_path
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed.'
  end

  private

  def extract_image_url(images)
    if images && images.any?
      images.first['url']
    else
      nil  # Return nil if no images are available
    end
  end
end
