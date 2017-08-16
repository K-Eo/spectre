require 'test_helper'

class DeviceTest < ActiveSupport::TestCase

  def setup
    @device = Device.fake
  end

  test "imei should be present" do
    @device.imei = ''
    assert_not @device.valid?
  end

  test "imei length should be less than 16" do
    @device.imei = 'a' * 17
    assert_not @device.valid?

    @device.imei = 'a' * 16
    assert @device.valid?
  end

  test "os should be present" do
    @device.os = ''
    assert_not @device.valid?
  end

  test "phone should be present" do
    @device.phone = ''
    assert_not @device.valid?
  end

  test "phone length should be less than 20" do
    @device.phone = 'a' * 21
    assert_not @device.valid?
    @device.phone = 'a' * 20
    assert @device.valid?
  end

  test "owner should be present" do
    @device.owner = ''
    assert_not @device.valid?
  end

  test "owner length should be less than 120" do
    @device.owner = 'a' * 121
    assert_not @device.valid?
    @device.owner = 'a' * 120
    assert @device.valid?
  end

  test "model should be present" do
    @device.model = ''
    assert_not @device.valid?
  end

  test "fake should return faker device instance" do
    fake = Device.fake
    assert_not fake.imei.nil?
    assert_not fake.os.nil?
    assert_not fake.phone.nil?
    assert_not fake.owner.nil?
    assert_not fake.model.nil?
  end

end
