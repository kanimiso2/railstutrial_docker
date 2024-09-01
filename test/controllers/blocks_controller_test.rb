require "test_helper"

class BlocksControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:archer)      # ブロックするユーザー（例: archer）
    @other_user = users(:lana)  # ブロック対象ユーザー（例: lana）
    log_in_as(@user)            # ログイン処理
  end

  test "should block a user" do
    assert_difference '@user.blocking.count', 1 do
      post blocks_path, params: { blocked_id: @other_user.id }
    end
    assert_redirected_to root_url
  end

  test "should unblock a user" do
    @user.block(@other_user)  # 事前にブロックしておく
    assert_difference '@user.blocking.count', -1 do
      delete block_path(@other_user)
    end
    assert_redirected_to root_url
  end

  test "should redirect create when not logged in" do
    delete logout_path # ログアウトしておく
    assert_no_difference '@user.blocking.count' do
      post blocks_path, params: { blocked_id: @other_user.id }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    delete logout_path # ログアウトしておく
    assert_no_difference '@user.blocking.count' do
      delete block_path(@other_user)
    end
    assert_redirected_to login_url
  end

end
