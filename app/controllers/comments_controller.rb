class CommentsController < ApplicationController
  
  def new
    authorize! :create, Comment
    if params[:type] == 'answer'
      @commentable = Answer.find(params[:id])
    else
      @commentable = Post.find(params[:id])
    end
    @comment = @commentable.comments.new
  end

  def create
    if params[:comment][:type] == 'answer'
      @answer = Answer.find(params[:comment][:id])
      @comment = @answer.comments.new(comment_params)
    else
      @post = Post.find(params[:comment][:id])
      @comment = @post.comments.new(comment_params)
    end
    @comment.user = current_user
    authorize! :create, @comment
    if @comment.save
      respond_to do |format|
        if params[:comment][:type] == 'answer'
          format.html { redirect_to post_path(@answer.post) }
        else
          format.html { redirect_to post_path(@post) }
        end
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
    authorize! :destroy, @comment
    @comment.destroy
    if @comment.commentable_type == 'Post'
      redirect_to post_path(@comment.commentable)
    else
      redirect_to post_path(@comment.commentable.post)
    end
  end

private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
