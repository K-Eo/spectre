require "application_system_test_case"

class PermissionsTest < ApplicationSystemTestCase
  test "user toggles monitor permission" do
    user = users(:eo)
    login_as(user)
    visit users_path

    within("tr#user_#{user.id}") do
      click_on "Monitor"
      assert_selector "a.btn-success[data-method='DELETE']", count: 1, text: "Monitor"
      click_on "Monitor"
      assert_selector "a.btn-secondary[data-method='PATCH']", count: 1, text: "Monitor"
      click_on "Monitor"
      assert_selector "a.btn-success[data-method='DELETE']", count: 1, text: "Monitor"
    end
  end

  test "user toggles alert permission" do
    user = users(:eo)
    login_as(user)
    visit users_path

    within("tr#user_#{user.id}") do
      click_on "Alertas"
      assert_selector "a.btn-success[data-method='DELETE']", count: 1, text: "Alertas"
      click_on "Alertas"
      assert_selector "a.btn-secondary[data-method='PATCH']", count: 1, text: "Alertas"
      click_on "Alertas"
      assert_selector "a.btn-success[data-method='DELETE']", count: 1, text: "Alertas"
    end
  end
end
