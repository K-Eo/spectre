require 'test_helper'

class TerminalsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @tenant = tenants(:spectre)
  end

  test "should get index" do
    get terminals_path(@tenant.organization)
    assert_response :success
  end

  test "should get new" do
    get new_terminal_path(@tenant.organization)
    assert_response :success
  end

  test "should post create" do
    assert_difference "Terminal.where(tenant_id: #{@tenant.id}).count" do
      post terminals_path(@tenant.organization),
            params: { terminal: { name: 'foobar' } }
      assert_redirected_to terminals_path
    end
  end

  test "should get show" do
    get terminal_path(@tenant.organization, Terminal.first)
    assert_response :success
  end

  test "should get edit" do
    get edit_terminal_path(@tenant.organization, Terminal.first)
    assert_response :success
  end

  test "should patch update" do
    terminal = Terminal.first
    patch terminal_path(@tenant.organization, terminal),
          params: { terminal: { name: 'foobar' } }
    assert_redirected_to terminal_path(terminal)
    terminal.reload
    assert terminal.name, 'foobar'
  end

  test "should destroy" do
    terminal = terminals(:ripper)
    assert_difference("Terminal.where(tenant_id: #{@tenant.id}).count", -1) do
      delete terminal_path(@tenant.organization, terminal)
    end

    assert_redirected_to terminals_path
  end

  test "should post send_token" do
    terminal = terminals(:ripper)
    post send_token_terminal_path(@tenant.organization, terminal),
          params: { device_email: { email: 'foo@bar.com' } }

    assert_not flash[:type]
    assert_equal 'Enviado instrucciones a <strong>foo@bar.com</strong>.', flash[:message]
    assert_redirected_to terminal_path(terminal)
  end

  test "should render danger on error when send_token" do
    terminal = terminals(:thread)
    post send_token_terminal_path(@tenant.organization, terminal),
          params: { device_email: { email: nil } }

    assert_equal 'danger', flash[:type]
    assert_equal 'No se ha podido enviar el correo. Verifique que sea correcto e intente nuevamente.',
                  flash[:message]
    assert_response :success
  end

  test "should destroy device pairing" do
    tenant = tenants(:spectre)
    terminal = Terminal.find_by(tenant_id: tenant.id, name: 'Ripper')
    delete pair_device_terminal_path(tenant, terminal)
    terminal.reload
    assert_not terminal.paired?
    assert_not_nil terminal.pairing_token
    assert_nil terminal.access_token
    assert_response :redirect
  end

end
