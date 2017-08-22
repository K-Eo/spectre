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

  test "should unpair device from web" do
    terminal = terminals(:ripper)

    # Should render terminal
    get terminal_path(terminal)
    assert_response :success

    # Should render associated device section
    assert_select 'h5', 'Associated Device'

    # Terminal already has one device as current
    assert_equal 1, terminal.devices.where(current: true).count

    # Delete action to unpair device
    delete pair_device_terminal_path(terminal)

    # We should have no device as curret
    assert_equal 0, terminal.devices.where(current: true).count

    terminal.reload

    # Access_token should be nil.
    assert_nil terminal.access_token
    # Pairing token shoul have new fresh token
    assert_match /[a-zA-Z0-9]{24}/, terminal.pairing_token
    # Paired should be set to false
    assert_not terminal.paired

    # Should redirect back to terminal
    assert_response :redirect
    follow_redirect!
    assert_response :success

    # Should render flash message
    assert_select 'div.alert-primary > div.container',
                  /El dispositivo ya no se encuentra asociado a esta terminal./
    # Should render pairing device section
    assert_select 'h4.card-title', /Asociar dispositivo/
  end

end
