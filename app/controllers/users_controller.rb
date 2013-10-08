class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user.update_karma
  end

  def index
    @users = User.by_rank
  end
end
