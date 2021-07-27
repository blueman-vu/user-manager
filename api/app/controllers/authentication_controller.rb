# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_token: auth_token)
  end

  def get_user
    json_response(UserSerializer.new(@current_user).as_json)
  end

  private

  def auth_params
    params.require(:authentication).permit(:email, :password)
  end
end
