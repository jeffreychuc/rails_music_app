class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def login!(user)
    # can just set user.session_token because sessions controller inherits from app controller
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
    # redirect_to users_url
    # doesnt need redirect due to before action
  end

  def logged_in?
    # cant return just current user, current user is user object
    # returns not not current user
    # not current user = false  if user is logged in
    # not not current user = true if user is logged in
    # not current user = true if current_user = nil
    !!current_user
  end

  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def require_logged_out
    redirect_to users_url unless !logged_in?
  end


  # current user searches by session token.
  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
end
