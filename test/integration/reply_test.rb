require "test_helper"

class ReplyTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    log_in_as(@user)
  end
  
  test "should allow reply creation on most liked page" do
    get most_liked_micropost_path(@micropost)
    assert_response :success
    
    assert_difference 'Micropost.count', 1 do
        post microposts_path, params: { micropost: { content: "This is a reply", parent_post_id: @micropost.id } }
      end
    assert_redirected_to micropost_path(@micropost)
    
  end

  test "should allow reply creation on newest page" do
    get newest_micropost_path(@micropost)
    assert_response :success
    
    assert_difference 'Micropost.count', 1 do
        post microposts_path, params: { micropost: { content: "This is a reply", parent_post_id: @micropost.id } }
    end
    assert_redirected_to  micropost_path(@micropost)
   
  end
end

