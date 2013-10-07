class PostsController < ApplicationController
  authorize_resource

  def new
    @post = Post.new(user: current_user)
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:success] = 'Post created'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.unanswered.paginate(page: params[:page], per_page: 20)
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :update, @post
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = 'Edit confirmed'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to root_path
  end

private
  
  def post_params
    params.require(:post).permit(:name, :content, :answered)
  end
end
