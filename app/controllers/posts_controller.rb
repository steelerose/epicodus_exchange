class PostsController < ApplicationController

  def new
    @post = Post.new(user: current_user)
    authorize! :create, @post
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    authorize! :create, @post
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
    if params[:keyword]
      @keywords = params[:keyword]
      @posts = Post.search(@keywords).paginate(page: params[:page], per_page: 10)
      render 'results'
    else
      @posts = Post.unanswered.paginate(page: params[:page], per_page: 10)
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :update, @post
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post
    if @post.update(post_params)
      flash[:success] = 'Edit confirmed'
      redirect_to post_path @post
    else
      render 'edit'
    end
  end

  def destroy
    post = Post.find(params[:id])
    authorize! :destroy, post
    post.destroy
    flash[:success] = 'Post deleted'
    redirect_to root_path
  end

private
  
  def post_params
    params.require(:post).permit(:name, :content, :answered)
  end
end
