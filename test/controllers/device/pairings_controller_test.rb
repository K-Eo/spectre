require 'test_helper'

class Device::PairingsControllerTest < ActionDispatch::IntegrationTest

  test "should create a pairing" do
    # Get target terminal, already has one device as current
    terminal = terminals(:thread)

    # Fake device to pair
    device = {
      imei: '538399670155719',
      os: 'Android KitKat',
      phone: '318-418-9663',
      owner: 'Susan M. Hadden',
      model: 'Moto X',
      pairing_token: terminal.pairing_token
    }

    # Start pairing
    assert_difference 'Device.count' do
      post device_pairings_path,
            params: { device: device },
            as: :json
    end

    # Assert response
    device_actual = JSON.parse(@response.body)
    assert_equal device[:imei], device_actual['imei']
    assert_equal device[:os], device_actual['os']
    assert_equal device[:phone], device_actual['phone']
    assert_equal device[:owner], device_actual['owner']
    assert_equal device[:model], device_actual['model']
    assert_not device_actual['created_at'].nil?
    assert_not device_actual['updated_at'].nil?

    # Access token should be present
    assert_not device_actual['access_token'].nil?

    # Should response with success
    assert_response :success

    # Fetch device with fake imei
    saved_device = terminal.devices.find_by(imei: device[:imei])

    # Device should be the current one
    assert saved_device.current?

    # Only one device should be current
    assert_equal 1, terminal.devices.where(current: true).count

    # Terminal should be updated to paired=true and token=nil
    terminal.reload
    assert terminal.paired?
    assert_nil terminal.pairing_token
    assert_not_nil terminal.access_token
  end

end
