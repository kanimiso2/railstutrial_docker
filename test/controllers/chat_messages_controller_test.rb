require "test_helper"

class ChatMessagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chat_room = chat_rooms(:one) # テスト用のチャットルームを設定
    @user = users(:michael) # テスト用のユーザーを設定
    @chat_room.users << @user # テストユーザーをチャットルームに追加
    log_in_as(@user) # ユーザーをログインさせる（ログインヘルパーを仮定）
  end

  test "should create chat message" do
    assert_difference '@chat_room.chat_messages.count', 1 do
      post chat_room_chat_messages_path(@chat_room), params: { chat_message: { message: "Hello, world!" } }
    end
    assert_redirected_to @chat_room
  end

end
