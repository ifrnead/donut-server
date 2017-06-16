class Message < ApplicationRecord
  belongs_to :author, dependent: :destroy, class_name: 'User'
  belongs_to :receiver, polymorphic: true

  validates :content, :author_id, :receiver_type, :receiver_id, presence: true
end
