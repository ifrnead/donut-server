class Message < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :room

  validates :content, :user_id, :room_id, presence: true
  validate :user_belongs_to_room?

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  def user_belongs_to_room?
    unless self.room.users.include?(self.user)
      errors.add(:user_id, "user ID #{self.user.id} does not belong to room ID #{self.room.id}")
    end
  end
end
