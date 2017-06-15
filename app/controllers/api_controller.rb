require 'errors'

class ApiController < ApplicationController
  include APIAuthentication
  skip_before_action :verify_authenticity_token

  def auth
    if params[:user].present? and params[:user][:username].present? and params[:user][:password].present?
      user = User.authenticate(username: params[:user][:username], password: params[:user][:password])
      json_response(token: user.token)
    else
      raise DonutServer::Errors::InvalidCredentialsError.new
    end
  end

end
