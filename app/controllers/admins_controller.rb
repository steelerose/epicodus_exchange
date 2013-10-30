class AdminsController < ApplicationController

	def create
		@user = User.find(params[:user_id])
		authorize! :make_admin, @user
		@user.update(admins_params)
		flash[:success] = 'Admin powers granted!'
		redirect_to user_path @user
	end

private

	def admins_params
		params.require(:user).permit(:admin)
	end

end