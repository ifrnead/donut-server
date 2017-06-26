require 'suap'

class Room < ApplicationRecord
  include Hashid::Rails

  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :messages

  before_create :set_title

  validates :suap_id, :year, :semester, :curricular_component, presence: true

  def self.fetch_by_user(user_token)
    rooms = Array.new
    rooms_data = SUAP::API.fetch_rooms_data(token: user_token, year: 2017, semester: 1)
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
    rooms
  end

  private

  def set_title
    self.title = self.curricular_component.split(" - ")[1]
  end

end
