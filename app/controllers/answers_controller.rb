class AnswersController < ApplicationController
  
  def new
    @post = Post.find(params[:post])
    @answer = @post.answers.new
    authorize! :create, @answer
  end

  def create
    @post = Post.find(params[:answer][:post_id])
    @answer = @post.answers.new(answer_params)
    authorize! :create, @answer
    @answer.user = current_user
    if @answer.save
      flash[:success] = 'Answer added'
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def edit
    @answer = Answer.find(params[:id])
    authorize! :update, @answer
  end

  def update
    @answer = Answer.find(params[:answer][:answer_id])
    authorize! :update, @answer
    if @answer.update(answer_params)
      flash[:success] = 'Edit confirmed'
      redirect_to post_path(@answer.post)
    else
      render 'edit'
    end
  end

  def destroy
    @answer = Answer.find(params[:answer_id])
    authorize! :destroy, @answer
    @answer.destroy
    flash[:success] = 'Answer deleted'
    redirect_to post_path(@answer.post)
  end

private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
