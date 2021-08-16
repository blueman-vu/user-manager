class PostsController < ApplicationController
  before_action :find_post, only: %i[show update destroy]
  before_action :check_permission, only: %i[update destroy]

  # GET /posts
  def index
    @posts = Post.all
    json_response(@posts)
  end

  # POST /posts
  def create
    @post = current_user.posts.create!(post_params)
    json_response(@post, :created)
  end

  # GET /posts/:id
  def show
    json_response(@post)
  end

  # PUT /posts/:id
  def update
    @post.update(post_params)
    head :no_content
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    head :no_content
  end

  private

  def correct_user
    current_user.role == 'admin' || current_user.id == @post.user_id
  end

  def check_permission
    raise(ExceptionHandler::NoPermission, Message.no_permission) unless correct_user
  end

  def post_params
    # whitelist params
    params.permit(:title, :content, :is_published)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
