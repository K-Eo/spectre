require 'test_helper'

class TerminalsControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get terminals_path
    assert_response :success
  end

  test "should get new" do
    get terminals_path
    assert_response :success
  end

  test "should post create" do
    assert_difference 'Terminal.count' do
      post terminals_path, params: { terminal: { name: 'foobar' } }
      assert_redirected_to terminals_path
    end
  end

  test "should get show" do
    get terminal_path(Terminal.first)
    assert_response :success
  end

  test "should get edit" do
    get edit_terminal_path(Terminal.first)
    assert_response :success
  end

  test "should patch update" do
    terminal = Terminal.first
    patch terminal_path(terminal), params: { terminal: { name: 'foobar' } }
    assert_redirected_to terminal_path(terminal)
    terminal.reload
    assert terminal.name, 'foobar'
  end

  test "should destroy" do
    terminal = terminals(:ripper)
    assert_difference('Terminal.count', -1) do
      delete terminal_path(terminal)
    end

    assert_redirected_to terminals_path
  end

  test "should post send_token" do
    terminal = terminals(:ripper)
    post send_token_terminal_path(terminal),
          params: { device_email: { email: 'foo@bar.com' } }

    assert_not flash[:type]
    assert_equal 'Enviado instrucciones a <strong>foo@bar.com</strong>.', flash[:message]
    assert_redirected_to terminal_path(terminal)
  end

  test "should render danger on error when send_token" do
    terminal = terminals(:thread)
    post send_token_terminal_path(terminal),
          params: { device_email: { email: nil } }

    assert_equal 'danger', flash[:type]
    assert_equal 'No se ha podido enviar el correo. Verifique que sea correcto e intente nuevamente.',
                  flash[:message]
    assert_response :success
  end

  test "pair_device POST should return success on pair" do
    terminal = terminals(:ripper)

    device = {
      imei: '538399670155719',
      os: 'Android KitKat',
      phone: '318-418-9663',
      owner: 'Susan M. Hadden',
      model: 'Moto X',
      pairing_token: terminal.pairing_token
    }

    post pair_device_terminals_path,
          params: { device: device },
          as: :json

    assert_response :success
  end

  test "pair_device POST should return error if missing device info" do
    terminal = terminals(:ripper)

    device = {
      imei: '',
      os: '',
      phone: '',
      owner: '',
      model: '',
      pairing_token: terminal.pairing_token
    }

    assert_difference('Device.count', 0) do
      post pair_device_terminals_path,
            params: { device: device },
            as: :json
    end

    device_actual = JSON.parse(@response.body)
    assert_equal '', device_actual['imei']
    assert_equal '', device_actual['os']
    assert_equal '', device_actual['phone']
    assert_equal '', device_actual['owner']
    assert_equal '', device_actual['model']
    assert device_actual['created_at'].nil?
    assert device_actual['updated_at'].nil?
    assert_not device_actual['errors'].nil?
    assert_response :unprocessable_entity
  end

  test "pair_device POST should return error if pairing token doesn't exist" do
    device = {
      imei: '538399810155719',
      os: 'Android KitKat',
      phone: '918-418-9663',
      owner: 'Mark M. Hadden',
      model: 'Moto E',
      pairing_token: ''
    }

    assert_difference('Device.count', 0) do
      post pair_device_terminals_path,
            params: { device: device },
            as: :json
    end

    device_actual = JSON.parse(@response.body)
    assert_equal device[:imei], device_actual['imei']
    assert_equal device[:os], device_actual['os']
    assert_equal device[:phone], device_actual['phone']
    assert_equal device[:owner], device_actual['owner']
    assert_equal device[:model], device_actual['model']
    assert device_actual['created_at'].nil?
    assert device_actual['updated_at'].nil?
    assert_response :not_found
  end

  test "pair_device DELETE web should return success on unpair" do
    terminal = terminals(:ripper)
    delete pair_device_terminal_path(terminal)
    assert_response :redirect
  end

  test "pair_device DELETE should return success on unpair" do
    terminal = terminals(:ripper)
    params = { access_token: terminal.access_token }

    delete pair_device_terminals_path,
            params: params,
            as: :json

    assert_response :success

    assert_equal 0, terminal.devices.where(current: true).count

    terminal.reload

    assert_nil terminal.access_token
    assert_match /[a-zA-Z0-9]/, terminal.pairing_token
    assert_not terminal.paired
  end

  test "pair_device DELETE should respond error if missing token_access" do
    terminal = terminals(:ripper)
    params = { access_token: '' }

    delete pair_device_terminals_path,
            params: params,
            as: :json

    assert_response :bad_request

    assert_equal 1, terminal.devices.where(current: true).count

    terminal.reload

    assert_nil terminal.pairing_token
    assert_match /[a-zA-Z0-9]/, terminal.access_token
    assert terminal.paired
  end

  test "should respond error if not found token_access" do
    terminal = terminals(:ripper)
    params = { access_token: 'foobar' }

    delete pair_device_terminals_path,
            params: params,
            as: :json

    assert_response :bad_request

    assert_equal 1, terminal.devices.where(current: true).count

    terminal.reload

    assert_nil terminal.pairing_token
    assert_match /[a-zA-Z0-9]/, terminal.access_token
    assert terminal.paired
  end

end
