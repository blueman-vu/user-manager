# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def index
    list_user = User.list_user(@current_user.role).paginate(page: params[:page], per_page: 10)
    json_response(ActiveModel::Serializer::CollectionSerializer.new(list_user).as_json)
  end

  def block_user
    user = User.find_by(id: params[:id])
    if @current_user.role == 'admin'
      user.is_block = true
    else
      json_response(false)
      return
    end
    json_response(user.save)
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
