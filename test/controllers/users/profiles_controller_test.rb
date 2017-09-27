require "test_helper"

class Users::ProfilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @params = { profile: { first_name: "foo", last_name: "bar" } }
  end

  def nuke(as, who)
    sign_in users(as) unless as.nil?
    target = users(who)
    patch profile_path(target),
          params: @params
  end

  test "user can update only his own profile" do
    nuke(:jo, :eo)
    assert_response :unauthorized

    nuke(:jo, :kat)
    assert_response :unauthorized

    nuke(:jo, :case)
    assert_response :unauthorized

    nuke(:jo, :jo)
    assert_redirected_to user_path(users(:jo))
  end

  test "moderator can update only users and own profile" do
    nuke(:kat, :eo)
    assert_response :unauthorized

    nuke(:kat, :leo)
    assert_response :unauthorized

    nuke(:kat, :kat)
    assert_redirected_to user_path(users(:kat))

    nuke(:kat, :jo)
    assert_redirected_to user_path(users(:jo))
  end

  test "admin can update any profile" do
    nuke(:eo, :eo)
    assert_redirected_to user_path(users(:eo))

    nuke(:eo, :kat)
    assert_redirected_to user_path(users(:kat))

    nuke(:eo, :jo)
    assert_redirected_to user_path(users(:jo))
  end

  test "users cannot update profiles of other companies" do
    nuke(:eo, :tom)
    assert_response :not_found

    nuke(:kat, :tom)
    assert_response :not_found

    nuke(:jo, :tom)
    assert_response :not_found
  end

  test "redirects to user path on success" do
    nuke(:eo, :eo)
    assert_redirected_to user_path(users(:eo))
  end

  test "responds with bad request if params is missing" do
    @params = nil
    nuke(:eo, :eo)
    assert_response :bad_request
  end
end
