class Api::UsersController < ApplicationController
  include APIAuthentication

  skip_before_action :verify_authenticity_token
  before_action :token_required

  def me
    json_response(current_user)
  end

  def show
    json_response(User.find(params[:id]).public_fields)
  end

  def index
    json_response(User.select(User::PUBLIC_FIELDS).all)
  end

end
