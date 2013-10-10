class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user.update_karma
    @posts = @user.posts.paginate(page: params[:page], per_page: 10)
  end

  def index
    if params[:keyword]
      @keywords = params[:keyword]
      @users = User.search(@keywords).paginate(page: params[:page], per_page: 10)
    else
      @users = User.by_rank.paginate(page: params[:page], per_page: 10)
    end
  end
end
