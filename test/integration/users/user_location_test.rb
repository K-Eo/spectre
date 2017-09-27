require "test_helper"

class UserLocationTest < ActionDispatch::IntegrationTest
  test "user updates his location" do
    user = users(:jo)
    sign_in user

    get user_path(user)
    assert_response :success

    assert_select "h5", "Localización"
    assert_select "form#edit_location_#{user.id}" do
      assert_select "input#location_lat[value='#{user.lat}']"
      assert_select "input#location_lng[value='#{user.lng}']"
      assert_select "input[type=submit]"
    end

    patch location_path(user),
          params: { location: { lat: 60, lng: 90 } }
    assert_redirected_to user_path(user)
    follow_redirect!
    assert_response :success
    assert_match "Datos guardados", @response.body
    assert_select "input#location_lat[value='60.0']"
    assert_select "input#location_lng[value='90.0']"
  end
end
