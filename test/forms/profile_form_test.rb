require 'test_helper'

class ProfileFormTest < ActiveSupport::TestCase

  def setup
    @user = users(:jo)
    @form = ProfileForm.new(@user)
    @first_name = 'Foo'
    @last_name = 'Bar'
  end

  def update
    params = { profile: { first_name: @first_name, last_name: @last_name } }
    @form.update(make_params(params))
  end

  test "update returns true" do
    assert update
  end

  test "update sets new profile" do
    update
    @user.reload
    assert_equal @first_name, @user.first_name
    assert_equal @last_name, @user.last_name
  end

  test "update returns false if first_name is too long" do
    @first_name = 'f' * 256
    assert_not update
    assert_equal 1, @form.errors.messages.length
  end

  test "update returns false if last_name is too long" do
    @last_name = 'f' * 256
    assert_not update
    assert_equal 1, @form.errors.messages.length
  end

  test "update returns false if first_name has invalid format" do
    @first_name = '!@$%&'
    assert_not update
    assert_equal 1, @form.errors.messages.length
  end

  test "update returns false if last_name has invalid format" do
    @last_name = '!@$%&'
    assert_not update
    assert_equal 1, @form.errors.messages.length
  end

  test "update sanitizes extra spaces" do
    @first_name = 'Foo  '
    @last_name = ' Bar     Baz '
    assert update
    @user.reload
    assert_equal 'Foo', @user.first_name
    assert_equal 'Bar Baz', @user.last_name
  end

  test "update returns false when params is not set" do
    assert_not @form.update(make_params({}))
  end

end
