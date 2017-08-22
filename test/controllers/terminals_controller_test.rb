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

  test "pair_device DELETE web should return success on unpair" do
    terminal = terminals(:ripper)
    delete pair_device_terminal_path(terminal)
    assert_response :redirect
  end

end
