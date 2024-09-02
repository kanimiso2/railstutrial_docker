class ChatRoomsController < ApplicationController
  before_action :logged_in_user
  def index
    @chat_rooms = current_user.chat_rooms
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @other_user = @chat_room.users.where.not(id: current_user.id).first
    @chat_messages = @chat_room.chat_messages.includes(:user)
    @chat_message = ChatMessage.new
  end

  def create
    existing_chat_room = ChatRoom.joins(:chat_rooms_users)
                               .where(chat_rooms_users: { user_id: [current_user.id, params[:user_id]] })
                               .group('chat_rooms.id')
                               .having('COUNT(DISTINCT chat_rooms_users.user_id) = 2')
                               .first

    if existing_chat_room
        # 既存のチャットルームが見つかった場合、そのチャットルームのページにリダイレクト
      redirect_to chat_room_path(existing_chat_room) and return
    end
    @chat_room = ChatRoom.new
    if @chat_room.save
      ChatRoomsUser.create(chat_room_id:@chat_room.id,user_id:current_user.id)
      ChatRoomsUser.create(chat_room_id: @chat_room.id, user_id: params[:user_id])
      redirect_to @chat_room
    else
      render root_url
    end
  end
end
