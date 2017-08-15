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
    terminal = terminals(:one)
    assert_difference('Terminal.count', -1) do
      delete terminal_path(terminal)
    end

    assert_redirected_to terminals_path
  end

  test "should post send_token" do
    terminal = terminals(:one)
    post send_token_terminal_path(terminal),
          params: { user: { email: 'foo@bar.com' } }
    assert_response :success
  end

end
