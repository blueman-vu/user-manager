class PostsController < ApplicationController
  before_action :find_post, only: %i[show update destroy like]
  before_action :check_permission, only: %i[update destroy]

  # GET /posts
  def index
    @posts = Post.lists(current_user.role, params[:search])
    paginate = @posts.paginate(page: params[:page], per_page: 10)
    json_response({posts: ActiveModel::Serializer::CollectionSerializer.new(paginate).as_json, pages: paginate.total_pages})
  end

  # POST /posts
  def create
    post = current_user.posts.create(post_params)
    if post  
      json_response({result: true})
    else
      json_response({message: post.errors})
    end
  end

  # GET /posts/:alias_name
  def show
    json_response(@post)
  end

  # PUT /posts/:alias_name
  def update
    @post.update(post_params)
    head :no_content
  end

  # DELETE /posts/:alias_name
  def destroy
    @post.destroy
    head :no_content
  end

  def like
    @post.update(like_count: @post.like_count.to_i + 1)
    json_response(@post.like_count)
  end

  private

  def correct_user
    current_user.role == 'admin' || (@post.present? && current_user.id == @post.user_id)
  end

  def check_permission
    raise(ExceptionHandler::NoPermission, Message.no_permission) unless correct_user
  end

  def post_params
    # whitelist params
    params.require(:post).permit(:title, :content, :is_published, :like_count)
  end

  def find_post
    @post = Post.find_by(alias_name: params[:alias_name])
    raise(ExceptionHandler::NoRecord, Message.no_record) if @post.blank?
  end
end
