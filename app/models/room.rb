require 'suap'

class Room < ApplicationRecord
  include Hashid::Rails

  has_many :subscriptions
  has_many :users, through: :subscriptions

  before_create :set_title

  def self.fetch_by_user(user_token)
    rooms = Array.new
    rooms_data = SUAP::API.fetch_rooms_data(user_token)
    rooms_data.each do |room_data|
      room = Room.find_by_suap_id(room_data["id"])
      if room.nil?
        room = Room.create(
          suap_id: room_data["id"],
          year: room_data["ano_letivo"],
          semester: room_data["periodo_letivo"],
          curricular_component: room_data["componente_curricular"]
        )
      end
      rooms << room
    end
  end

  private

  def set_title
    # TODO
  end

end
