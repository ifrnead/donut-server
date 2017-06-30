require 'errors'

class Api::RoomsController < ApplicationController
  include APIAuthentication

  skip_before_action :verify_authenticity_token
  before_action :token_required

  # Index rooms
  api :GET, "/rooms", "Rooms list"
  formats [ 'json' ]

  def index
    json_response(current_user.rooms)
  end

  # Show room
  api :GET, "/rooms/:room_id", "Room details"
  formats [ 'json' ]
  param :room_id, Integer, desc: "Room ID", required: true
  error 404, 'Record not found: no room found with the provided Room ID'
  error 401, 'Unauthorized: current user doesn\'t belongs to the provided Room ID'

  def show
    begin
      room = Room.find(params[:room_id])
      if room.include?(current_user)
        json_response(room)
      else
        raise DonutServer::Errors::UnauthorizedError.new
      end
    rescue ActiveRecord::RecordNotFound
      raise DonutServer::Errors::RecordNotFound.new
    end
  end

  resource_description do
    description <<-EOS
      === Room fields
      The Room model has the following fields.
      - <b>suap_id (integer)</b>: SUAP ID
      - <b>year (integer)</b>: academic year
      - <b>semester (integer)</b>: academic semester
      - <b>curricular_component (String)</b>: curricular component
      - <b>title (String)</b>: room title (this field is automatically filled)
      === Authorization
      All resources described bellow require authorization by token. Provide the User Token through the HTTP header using the following format.
        Authorization: Token <user_token>
    EOS
    error 401, 'Unauthorized: invalid token or token was not provided'
  end
end
