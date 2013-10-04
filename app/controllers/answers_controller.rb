class AnswersController < ApplicationController
  def new
    @post = Post.find(params[:post])
    @answer = @post.answers.new
  end

  def create
    @post = Post.find(params[:answer][:post_id])
    @answer = @post.answers.new(answer_params)
    if @answer.save
      flash[:success] = 'Answer added'
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:answer][:answer_id])
    @answer.update(answer_params)
    if @answer.save
      redirect_to post_path(@answer.post)
    else
      render 'edit'
    end
  end

  def destroy
    @answer = Answer.find(params[:answer_id])
    @answer.destroy
    redirect_to post_path(@answer.post)
  end

private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
