class Api::RoomsController < ApplicationController
  include APIAuthentication

  skip_before_action :verify_authenticity_token
  before_action :token_required

  def rooms_by_user
    json_response(User.find(params[:user_id]).rooms)
  end
end
