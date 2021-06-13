class Api::V1::SessionsController < ApplicationController
  def create
    login_token = params[:login_token].to_s
    decoded_token = JsonWebToken.decode(login_token)

    if decoded_token && JsonWebToken.valid_payload(decoded_token.first)
      user = User.find_by(login_token: login_token)
      if user
        render json: { auth_token: user.generate_auth_token }
      else
        render json: { error: 'Invalid Request' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid Request' }, status: :unauthorized
    end
  end
end
