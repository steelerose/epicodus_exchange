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
      respond_to do |format|
        format.html { redirect_to post_path(@answer.post) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(@comment.answer.post)
  end

private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
