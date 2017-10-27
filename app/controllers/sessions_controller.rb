class SessionsController < ApplicationController
  before_action :require_logged_in, only: [:destroy]
  before_action :require_logged_out, only: [:new, :create]

  def new
    render :new
  end

  def create
    # fail
    user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    if user.nil?
      flash.now[:error] = ["invalid user"]
      render :new
    else
      login!(user)
      redirect_to user_url(user)
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
end
