class Api::MessagesController < ApplicationController
  include APIAuthentication

  skip_before_action :verify_authenticity_token
  before_action :token_required

  def messages_by_room
    json_response(Room.find(params[:room_id]).messages)
  end

  def create
    message = Message.new(message_params)
    message.author = current_user
    if message.save
      json_response(message, :created)
    else
      json_response(message.errors, :bad_request)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_type, :receiver_id)
  end

end
