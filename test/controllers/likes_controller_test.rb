require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:michael)
        @micropost = microposts(:orange)
    end
  
    test "create should require logged-in user" do
        assert_no_difference 'Like.count' do
          post create_like_path(micropost_id: @micropost.id)
        end
        assert_redirected_to login_url
    end
    
    test "destroy should require logged-in user" do
        assert_no_difference 'Like.count' do
          delete delete_like_path(micropost_id: @micropost.id)
        end
        assert_redirected_to login_url
    end

    # ログインしているユーザーが「いいね」できるかどうかのテスト
  test "logged-in user should be able to like a micropost" do
    log_in_as(@user)
    assert_difference 'Like.count', 1 do
      post create_like_path(micropost_id: @micropost.id)
    end
    assert_redirected_to root_url
  end

  # ログインしているユーザーが「いいね解除」できるかどうかのテスト
  test "logged-in user should be able to unlike a micropost" do
    log_in_as(@user)
    @user.like(@micropost)
    assert_difference 'Like.count', -1 do
      delete delete_like_path(@micropost.id)
    end
    assert_redirected_to root_url
  end
  
end