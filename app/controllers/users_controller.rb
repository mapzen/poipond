class UsersController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def show
    @user = User.find_by_display_name(params[:display_name])
  end

  def pois
    @user = User.find_by_display_name(params[:display_name])
    @pois = @user.pois
  end

  def new
    @user = User.new
  end

  def create
    user_hash = session[:auth_hash]
    user_hash[:email] = params[:email]
    @user = User.create(user_hash)
    if @user.persisted?
      session[:user_id] = @user.id
      session.delete(:auth_hash)
      redirect_to home_url
    else
      render :new
    end
  end

end
