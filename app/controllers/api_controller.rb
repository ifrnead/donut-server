require 'errors'

class ApiController < ApplicationController
  include APIAuthentication
  skip_before_action :verify_authenticity_token

  # Authentication
  api :POST, '/auth', "Authentication"
  formats [ 'json' ]
  param :user, Hash, desc: 'User' do
    param :username, String, desc: 'Username', required: true
    param :password, String, desc: 'Password', required: true
  end
  error 400, "Bad request: one or more mandatory fields wasn't provided"
  error 401, "Unauthorized: invalid credentials provided"
  example "'user': { 'username': '3284983', 'password': 'mypass' }"

  def auth
    if params[:user].present? and params[:user][:username].present? and params[:user][:password].present?
      user = User.authenticate(username: params[:user][:username], password: params[:user][:password])
      json_response(token: user.token)
    else
      raise DonutServer::Errors::InvalidCredentialsError.new
    end
  end

  resource_description do
    description <<-EOS
      === Authorization
      In order to have access to the resources provided by this API, you need to authenticate an user using the '/api/auth' resource. This resource will provide a token needed to access all other resources.
    EOS
  end

end
