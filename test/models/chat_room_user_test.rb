require "test_helper"

class ChatRoomUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save chat rooms user without chat_room and user" do
    chat_rooms_user = ChatRoomsUser.new
    assert_not chat_rooms_user.save, "Saved the chat rooms user without a chat room and user"
  end
end
