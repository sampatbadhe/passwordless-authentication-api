class User < ApplicationRecord
  #  downcase the email attribute before saving
  before_save { self.email = email.downcase }

  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false },
    presence: true

  def send_magic_link
    generate_login_token

    UserMailer.magic_link(self, login_link).deliver_now
  end

  # generates login token to authorize user
  def generate_login_token
    # create a login_token and set it up to expiry in 60 minutes
    payload = {
      email: email,
      exp: 1.hour.from_now.to_i
    }
    # set login_token to validate last sent login token
    self.login_token = generate_token(payload)
    save!
  end

  # returns the login_link which is to be included in the email
  def login_link
    Rails.application.routes.url_helpers.api_v1_sessions_create_url(login_token: login_token, host: 'localhost:3000')
  end

  # generates auth token to authenticate the further request once user is authorized
  def generate_auth_token
    self.login_token = nil
    self.login_token_verified_at = Time.now
    self.save

    payload = {
      user_id: id,
      login_token_verified_at: login_token_verified_at,
      exp: 1.day.from_now.to_i
    }

    generate_token(payload)
  end

  private

  def generate_token(token_payload)
    JsonWebToken.encode(token_payload)
  end
end
