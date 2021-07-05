class ApplicationController < ActionController::API

  private
  # Validates the token and user and sets the @current_user scope
  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload)
      return invalid_authentication
    end

    load_current_user!

    invalid_authentication unless @current_user
    invalid_authentication if @current_user.login_token_verified_at.to_s != payload['login_token_verified_at']
  end

  # Returns 401 response. To handle malformed / invalid requests.
  def invalid_authentication
    render json: { error: 'Invalid Request' }, status: :unauthorized
  end

  private

  # Deconstructs the Authorization header and decodes the JWT token.
  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token).first
  rescue
    nil
  end

  # Sets the @current_user with the user_id from the payload
  def load_current_user!
    @current_user = User.find_by(id: payload['user_id'])
  end
end
