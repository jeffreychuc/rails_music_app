class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save
      login!(user)
      redirect_to user_url(user)
    else
      flash.now[:errors] = ["Invalid some shit, fix yo stuff"]
      render :new
    end
  end

  def show
    render :show
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

end
