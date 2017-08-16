require 'test_helper'

class DeviceEmailTest < ActiveSupport::TestCase

  test "should be valid" do
    form = DeviceEmail.new(email: 'foo@bar.com')
    assert form.valid?
  end

  test "email should be present" do
    form = DeviceEmail.new
    assert_not form.valid?
  end

  test "email should be valid" do
    form = DeviceEmail.new(email: 'foobar')
    assert_not form.valid?
  end

end
