require "test_helper"

class UserProfileTest < ActionDispatch::IntegrationTest
  test "user updates his profile" do
    user = users(:jo)
    sign_in(user)

    get user_path(user)
    assert_response :success

    assert_select "h5", "Perfil"
    assert_select "form#edit_profile_#{user.id}" do
      assert_select "input#profile_first_name[value=#{user.first_name}]"
      assert_select "input#profile_last_name[value=#{user.last_name}]"
      assert_select "input[type=submit]"
    end

    patch profile_path(user),
          params: { profile: { first_name: "foo", last_name: "bar" } }

    assert_redirected_to user_path(user)
    follow_redirect!
    assert_response :success
    assert_match "Datos guardados", @response.body
    assert_select "input#profile_first_name[value=foo]"
    assert_select "input#profile_last_name[value=bar]"
  end
end
