class ChatMessagesController < ApplicationController
  before_action :logged_in_user
  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @chat_message = @chat_room.chat_messages.build(chat_message_params)
    @chat_message.user = current_user
    if @chat_message.save
      redirect_to @chat_room
    else
      @chat_messages = @chat_room.chat_messages.includes(:user)
      render "chat_rooms/show"
    end
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:message)
  end
end
