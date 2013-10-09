class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user.update_karma
  end

  def index
    if params[:keyword]
      @keywords = params[:keyword]
      @users = User.search(@keywords)
    else
      @users = User.by_rank.paginate(page: params[:page], per_page: 20)
    end
  end
end
