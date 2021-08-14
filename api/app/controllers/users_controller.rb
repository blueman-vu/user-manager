# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = Auth::AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def index
    list_user = User.list_user(@current_user.role, params[:search])
    paginate = list_user.paginate(page: params[:page], per_page: 10)
    json_response({users: ActiveModel::Serializer::CollectionSerializer.new(paginate, role: @current_user.role).as_json, pages: paginate.total_pages})
  end

  def delete_user
    @user = User.find(params[:id])
    if @user == @current_user || @user.role == 'admin'
      json_response({message: 'Cannot delete this user'})
      return
    end
    if @current_user.role == 'admin'
      if @user.delete
        json_response({result: true})
      else
        json_response({message: @users.errors})
      end
      return
    end
    json_response({message: 'Somethings went wrong!'})
  end

  def block_user
    @user = User.find(params[:id])
    if @user == @current_user || @user.role == 'admin'
      json_response({message: 'Cannot block this user'})
      return
    end

    if @current_user.role == 'admin'
      @user.is_block = true
      if @user.save
        json_response({result: true})
      else
        json_response({message: @users.errors})
      end
      return
    end
    json_response({message: 'Somethings went wrong!'})
  end

  private

  def user_params
    params.permit(
      :username,
      :name,
      :email,
      :password
    )
  end
end
