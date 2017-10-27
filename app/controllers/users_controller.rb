class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    render "hello world"
  end
end
