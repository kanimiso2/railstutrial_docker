require "test_helper"

class ChatMessageTest < ActiveSupport::TestCase
  test "should not save chat message without content" do
    chat_message = ChatMessage.new
    chat_message.chat_room = chat_rooms(:one) # assuming you have fixtures or factory
    chat_message.user = users(:michael) # assuming you have fixtures or factory
    assert_not chat_message.save, "Saved the chat message without content"
  end
end
