class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, :room_id, presence: true
end
