class ChatsController < ApplicationController
  def index
    @chats = Chat.all
  end

  def create
    @chat = Chat.build(chat_params)
    @chat.save

    # redirect_to chats_path
    # render json: {}, status: :no_content

    # Just so I can clear up the input field
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message)
  end
end
