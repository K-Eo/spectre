require "test_helper"

class PasswordFormTest < ActiveSupport::TestCase
  def setup
    @user = users(:jo)
    @form = PasswordForm.new(@user)
    @params = { user: { password: "foobar",
                        password_confirmation: "foobar",
                        current_password: "password" } }
  end

  def update
    @form.update(make_params(@params))
  end

  test "update returns true" do
    assert update
  end

  test "update returns false if params is not set" do
    @params = {}
    assert_not update
  end
end
