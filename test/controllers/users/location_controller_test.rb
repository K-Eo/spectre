require 'test_helper'

class Users::LocationControllerTest < ActionDispatch::IntegrationTest

  def setup
    @params = { location: { lat: 22.22, lng: -24.44 } }
  end

  def nuke(as, who)
    sign_in users(as) unless as.nil?
    target = users(who)
    patch location_path(target),
          params: @params,
          xhr: true
  end

  test "admin can update geo from any account" do
    nuke(:eo, :eo)
    assert_response :success

    nuke(:eo, :kat)
    assert_response :success

    nuke(:eo, :jo)
    assert_response :success
  end

  test "moderator can update geo from own and users account" do
    nuke(:kat, :eo)
    assert_response :unauthorized

    nuke(:kat, :leo)
    assert_response :unauthorized

    nuke(:kat, :kat)
    assert_response :success

    nuke(:kat, :jo)
    assert_response :success
  end

  test "user can update geo from only own account" do
    nuke(:jo, :eo)
    assert_response :unauthorized

    nuke(:jo, :kat)
    assert_response :unauthorized

    nuke(:jo, :case)
    assert_response :unauthorized

    nuke(:jo, :jo)
    assert_response :success
  end

  test "any can't update geo from users of other companies" do
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
