require 'test_helper'

class DeviceTerminalPairingTest < ActionDispatch::IntegrationTest

  test "should pair a device with terminal" do
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
      post pair_device_terminals_path,
            params: { device: device },
            as: :json
    end

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
    assert terminal.pairing_token.nil?
  end

end
