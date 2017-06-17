class Api::MessagesController < ApplicationController
  include APIAuthentication

  skip_before_action :verify_authenticity_token
  before_action :token_required

  # Messages by room
  api :GET, "/rooms/:room_id/messages", "Messages by room"
  formats [ 'json' ]
  param :room_id, Fixnum, desc: "Room ID", required: true
  error 404, 'Record not found: no room was found with the provided Room ID'

  def messages_by_room
    begin
      json_response(Room.find(params[:room_id]).messages)
    rescue ActiveRecord::RecordNotFound
      raise DonutServer::Errors::RecordNotFound.new
    end
  end

  # Create message
  api :POST, '/messages/create', "Create a new message"
  formats [ 'json' ]
  param :message, Hash, desc: 'Message' do
    param :content, String, desc: 'Message content', required: true
    param :receiver_type, String, desc: 'Model name which will receive the message (User or Room)', required: true
    param :receiver_id, Fixnum, desc: 'Model ID which will receive the message (User ID or Room ID)', required: true
  end
  error 400, "Bad request: one or more mandatory fields wasn't provided"
  example "'message': { 'content': 'Sample message', 'receiver_type': 'Room', 'received_id': '1' }"
  example "'message': { 'content': 'Sample message', 'receiver_type': 'User', 'received_id': '2' }"

  def create
    message = Message.new(message_params)
    message.author = current_user
    if message.save
      json_response(message, :created)
    else
      json_response(message.errors, :bad_request)
    end
  end

  resource_description do
    description <<-EOS
      === Message fields
      The Message model has the following fields.
      - <b>content (String)</b>: message content
      - <b>author_id (integer)</b>: ID of the sender
      - <b>receiver_type (String)</b>: model name which the message was sent to ('User' or 'Room')
      - <b>receiver_id (integer)</b>: model ID which the message was sent to (User ID ou Room ID)
      === Authorization
      All resources described bellow require authorization by token. Provide the User Token through the HTTP header using the following format.
        Authorization: Token <user_token>
    EOS
    error 401, 'Unauthorized: invalid token or token was not provided'
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_type, :receiver_id)
  end

end
