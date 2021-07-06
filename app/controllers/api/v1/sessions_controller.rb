class Api::V1::SessionsController < ApplicationController
  def create
    login_token = params[:login_token].to_s
    decoded_token = JsonWebToken.decode(login_token).first

    if decoded_token && JsonWebToken.valid_payload(decoded_token)
      user = User.find_by(email: decoded_token['email'])

      if user && user.login_token_sent_at.to_s == decoded_token['login_token_sent_at']
        render json: { auth_token: user.generate_auth_token }
      else
        render_invalid_authentication
      end
    else
      render_invalid_authentication
    end
  end
end
