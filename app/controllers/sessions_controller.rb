class SessionsController < ApplicationController

  def new
    @location = "login"
    render :new
  end

  def create
    user = User.find_by_credentials(params[:email], params[:password])
    if user.nil?
      flash.now[:error] = ["invalid user"]
      render :new
    else
      login!(user)
      redirect_to user_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end
end
