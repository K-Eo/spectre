require 'test_helper'

class Users::LocationsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @params = { location: { lat: 22.22, lng: -24.44 } }
  end

  def nuke(as, who)
    sign_in users(as) unless as.nil?
    target = users(who)
    patch location_path(target),
          params: @params
  end

  test "admin can update geo from any account" do
    nuke(:eo, :eo)
    assert_redirected_to user_path(users(:eo))

    nuke(:eo, :kat)
    assert_redirected_to user_path(users(:kat))

    nuke(:eo, :jo)
    assert_redirected_to user_path(users(:jo))
  end

  test "moderator can update geo from own and users account" do
    nuke(:kat, :eo)
    assert_response :unauthorized

    nuke(:kat, :leo)
    assert_response :unauthorized

    nuke(:kat, :kat)
    assert_redirected_to user_path(users(:kat))

    nuke(:kat, :jo)
    assert_redirected_to user_path(users(:jo))
  end

  test "user can update geo from only own account" do
    nuke(:jo, :eo)
    assert_response :unauthorized

    nuke(:jo, :kat)
    assert_response :unauthorized

    nuke(:jo, :case)
    assert_response :unauthorized

    nuke(:jo, :jo)
    assert_redirected_to user_path(users(:jo))
  end

  test "any can't update geo from users of other companies" do
    nuke(:eo, :tom)
    assert_response :not_found

    nuke(:kat, :tom)
    assert_response :not_found

    nuke(:jo, :tom)
    assert_response :not_found
  end

  test "redirects to user path on success" do
    nuke(:eo, :eo)
    assert_equal 'Datos guardados', flash[:notice]
    assert_redirected_to user_path(users(:eo))
  end

  test "returns bad request on failure" do
    @params = nil
    nuke(:eo, :eo)
    assert_response :bad_request
  end
end
