class CommentsController < ApplicationController
  authorize_resource
  
  def new
    @answer = Answer.find(params[:answer])
    @comment = @answer.comments.new
  end

  def create
    @answer = Answer.find(params[:comment][:answer_id])
    @comment = @answer.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = 'Comment added'
      redirect_to post_path(@answer.post)
    else
      render 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
  end

  def update
    @comment = Comment.find(params[:comment][:comment_id])
    @comment.update(comment_params)
    if @comment.save
      redirect_to post_path(@comment.answer.post)
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment.destroy
    redirect_to post_path(@comment.answer.post)
  end

private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
