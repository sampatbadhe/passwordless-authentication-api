class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  private
  # Validates the token and user and sets the @current_user scope
  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload)
      return render_invalid_authentication
    end

    load_current_user!

    render_invalid_authentication unless @current_user
    render_invalid_authentication if @current_user.login_token_verified_at.to_s != payload['login_token_verified_at']
  end

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

  # Returns 404 response.
  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  # Returns 401 response. To handle malformed / invalid requests.
  def render_invalid_authentication
    render json: { error: 'Invalid Request' }, status: :unauthorized
  end

  # Returns 422 response.
  def render_unprocessable_entity_response(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
