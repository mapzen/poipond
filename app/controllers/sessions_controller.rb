class SessionsController < ApplicationController

  def create
    auth = auth_hash(request.env['omniauth.auth'])
    if user = User.find_by_provider_and_uid(auth[:provider], auth[:uid])
      user.update_attributes(auth)
      session[:user_id] = user.id
      cookies.permanent.signed[:permanent_user_id] = user.id
      redirect_to home_url
    else
      session[:auth_hash] = auth
      redirect_to signup_url
    end  
  end

  def destroy
    session.delete(:user_id)
    redirect_to home_url
  end

  private

  def auth_hash(auth_obj)
    {
      provider: auth_obj.provider,
      uid: auth_obj.uid,
      token: auth_obj.credentials.token,
      secret: auth_obj.credentials.secret,
      display_name: auth_obj.info.display_name,
      image_url: auth_obj.info.image_url,
      lat: auth_obj.info.lat,
      lon: auth_obj.info.lon
    }
  end

end
