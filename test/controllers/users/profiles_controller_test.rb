require 'test_helper'

class Users::ProfilesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @params = { profile: { first_name: 'foo', last_name: 'bar' } }
  end

  def nuke(as, who)
    sign_in users(as) unless as.nil?
    target = users(who)
    patch profile_path(target),
          params: @params,
          xhr: true
  end

  test "user can update only his own profile" do
    nuke(:jo, :eo)
    assert_response :unauthorized

    nuke(:jo, :kat)
    assert_response :unauthorized

    nuke(:jo, :case)
    assert_response :unauthorized

    nuke(:jo, :jo)
    assert_response :success
  end

  test "moderator can update only users and own profile" do
    nuke(:kat, :eo)
    assert_response :unauthorized

    nuke(:kat, :leo)
    assert_response :unauthorized

    nuke(:kat, :kat)
    assert_response :success

    nuke(:kat, :jo)
    assert_response :success
  end

  test "admin can update any profile" do
    nuke(:eo, :eo)
    assert_response :success

    nuke(:eo, :kat)
    assert_response :success

    nuke(:eo, :jo)
    assert_response :success
  end

  test "users can't update profiles of other companies" do
    nuke(:eo, :tom)
    assert_response :not_found

    nuke(:kat, :tom)
    assert_response :not_found

    nuke(:jo, :tom)
    assert_response :not_found
  end

  test "returns javascript on success" do
    nuke(:eo, :eo)
    assert_response :success
    assert_equal 'text/javascript', @response.content_type
  end

  test "returns javascript on failure" do
    @params = nil
    nuke(:eo, :eo)
    assert_response :bad_request
    assert_equal 'text/javascript', @response.content_type
  end
end
