require 'test_helper'

class UsersSearchTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @archer = users(:archer)
    @lana = users(:lana)
    @malory = users(:malory)
    @inactive = users(:inactive)
  end

  test "search returns matching activated users" do
    log_in_as(@user)
    # "Archer" で検索し、Sterling Archer と Malory Archer が含まれているか確認
    get search_users_path, params: { query: "Archer" }
    assert_template 'users/index'
    assert_match @archer.name, response.body
    # 検索結果に含まれるべきでないユーザーが表示されていないことを確認
    assert_no_match @lana.name, response.body
    assert_no_match @inactive.name, response.body
  end
end
