class Chat < ApplicationRecord
  after_create_commit :broadcast_chat

  def broadcast_chat
    # With all the default names
    # broadcast_append_to(
    #   "chats",
    #   target: "chats",
    #   partial: "chats/chat",
    #   locals: { chat: self }
    # )

    broadcast_append_to(
      "chat_stream", # turbo_stream_from "chat_stream" in views/chat/index
      target: "chats-block", # DOM id for Turbo Stream
      partial: "chats/chat_message",
      locals: { chat_message: self } # should match variable name in the partial
    )
  end
end
