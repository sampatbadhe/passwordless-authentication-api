class Api::V1::AuthenticationController < ApplicationController
  def create
    # the user might already exist in our db or it might be a new user
    user = User.find_or_create_by!(email: params[:user][:email])

    user.send_magic_link

    head :ok
  end
end
