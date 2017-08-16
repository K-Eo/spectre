require 'test_helper'

class DeviceTest < ActiveSupport::TestCase

  test "fake should return faker device instance" do
    fake = Device.fake
    assert_not fake.imei.nil?
    assert_not fake.os.nil?
    assert_not fake.phone.nil?
    assert_not fake.owner.nil?
    assert_not fake.model.nil?
  end

end
