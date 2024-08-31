require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "should get show" do
    @user = users(:michael)
    log_in_as(@user)
    get micropost_path(@micropost)
    assert_response :success
  end
  test "should get most_liked" do
    @user = users(:michael)
    log_in_as(@user)
    get most_liked_micropost_path(@micropost)
    assert_response :success
  end
  test "should get newest" do
    @user = users(:michael)
    log_in_as(@user)
    get newest_micropost_path(@micropost)
    assert_response :success
  end

end
