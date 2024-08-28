require "test_helper"
#---------------------------------------------------------
class NiceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
  end

  test "should require login to like a post" do
    assert_no_difference 'Like.count' do
      post create_like_path(micropost_id: @micropost.id)
    end
    assert_redirected_to login_url
  end

  test "logged-in user can like a post" do
    log_in_as(@user)
    assert_difference 'Like.count', 1 do
      post create_like_path(micropost_id: @micropost.id)
    end
    assert_redirected_to root_url
  end

  test "logged-in user can unlike a post" do
    log_in_as(@user)
    @user.like(@micropost)
    assert_difference 'Like.count', -1 do
      delete delete_like_path(@micropost.id)
    end
    assert_redirected_to root_url
  end
end