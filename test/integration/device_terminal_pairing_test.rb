require 'test_helper'

class DeviceTerminalPairingTest < ActionDispatch::IntegrationTest

  test "should destroy device pairing from web" do
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
