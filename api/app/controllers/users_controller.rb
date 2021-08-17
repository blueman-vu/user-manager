# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :find_user, only: %i[delete_user block_user]
  before_action :check_permission, only: %i[delete_user block_user]

  def create
    user = User.create!(user_params)
    auth_token = Auth::AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def index
    list_user = User.list_user(current_user.role, params[:search])
    paginate = list_user.paginate(page: params[:page], per_page: 10)
    json_response({users: ActiveModel::Serializer::CollectionSerializer.new(paginate, role: current_user.role).as_json, pages: paginate.total_pages})
  end

  def delete_user    
    if @user.delete
      json_response({result: true})
    else
      json_response({message: @users.errors})
    end
  end

  def block_user
    @user.is_block = true
    if @user.save
      json_response({result: true})
    else
      json_response({message: @users.errors})
    end
  end
  
  def top_5
    top_5 = User.top_like.take(5)
    json_response(top_5)
  end

  private

  def invalid_user
    @user.role == 'admin' || @user == current_user || current_user.role != 'admin'
  end

  def check_permission
    raise(ExceptionHandler::NoPermission, Message.no_permission) if invalid_user 
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(
      :username,
      :name,
      :email,
      :password
    )
  end
end
