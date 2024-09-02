require "test_helper"

class ChatRoomsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # 既存のユーザー
    log_in_as(@user) # ログインするヘルパーメソッド
    @chat_room = chat_rooms(:one) # 既存のチャットルーム
    @chat_room.users << @user  # ユーザーにチャットルームを関連付ける
  end

  test "should get index" do
    get chat_rooms_path
    assert_response :success
    assert_select 'h1', 'Chat Rooms'
  end

  test "should get show" do
    get chat_room_path(@chat_room)
    assert_response :success
  end

  test "should create chat room" do
    assert_difference 'ChatRoom.count', 1 do
      post chat_rooms_path, params: { user_id: users(:archer).id }
    end
    assert_redirected_to ChatRoom.last
  end
  
end
