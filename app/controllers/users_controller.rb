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

  def destroy
    @user = User.find(params[:id])
    authorize! :admin_destroy, @user
    if @user.admin? && User.where(admin: true).length == 1
      flash[:error] = 'Please assign a new admin before deleting your account'
    else
      @user.destroy
      if @user == current_user
        flash[:success] = 'Your account has been deleted'
      else
        flash[:success] = 'Account deleted'
      end
    end
    redirect_to root_path
  end
end
