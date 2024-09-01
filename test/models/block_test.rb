require "test_helper"

class BlockTest < ActiveSupport::TestCase
  def setup
    @block = Block.new(blocker_id: users(:michael).id,  # ブロックするユーザー
                       blocked_id: users(:archer).id)  # ブロックされるユーザー
  end

  test "should be valid" do
    assert @block.valid?
  end

  test "should require a blocker_id" do
    @block.blocker_id = nil
    assert_not @block.valid?
  end

  test "should require a blocked_id" do
    @block.blocked_id = nil
    assert_not @block.valid?
  end

end
