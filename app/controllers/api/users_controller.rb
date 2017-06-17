class Api::UsersController < ApplicationController
  include APIAuthentication

  skip_before_action :verify_authenticity_token
  before_action :token_required

  # Current user information
  api :GET, "/users/me", "Current user information"
  formats [ 'json' ]

  def me
    json_response(current_user)
  end

  # User details
  api :GET, "/users/:user_id", "User details"
  formats [ 'json' ]
  param :user_id, Fixnum, desc: "User ID", required: true
  error 404, 'Record not found: no user was found with the provided User ID'

  def show
    begin
      json_response(User.find(params[:user_id]).public_fields)
    rescue ActiveRecord::RecordNotFound
      raise DonutServer::Errors::RecordNotFound.new
    end
  end

  # User list
  api :GET, "/users", "User list"
  formats [ 'json' ]

  def index
    json_response(User.select(User::PUBLIC_FIELDS).all)
  end

  resource_description do
    description <<-EOS
      === User fields
      The User model has the following fields.
      - <b>email (string)</b>: e-mail address
      - <b>username (string)</b>: username
      - <b>suap_token (string)</b>: SUAP token
      - <b>suap_token_expiration_date (Date)</b>: SUAP token expiration date
      - <b>suap_id (integer)</b>: User ID on SUAP
      - <b>enroll_id (integer)</b>: Enrollment ID on SUAP
      - <b>name (string)</b>: name
      - <b>fullname (string)</b>: fullname
      - <b>url_profile_pic (string)</b>: URL of the profile picture on SUAP
      - <b>category (string)</b>: User category on SUAP
      - <b>token (string)</b>: authorization token
      === Authorization
      All resources described bellow, except '/api/auth', require authorization by token. Provide the User Token through the HTTP header using the following format.
        Authorization: Token <user_token>
    EOS
    error 401, 'Unauthorized: invalid token or token was not provided'
  end

end
