class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "chat_room_#{message.receiver.id}_channel", message: message.to_json
  end
end
