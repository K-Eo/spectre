require 'test_helper'

class TerminalTest < ActiveSupport::TestCase

  def setup
    @tenant = tenants(:spectre)
  end

  test "should be invalid" do
    terminal = Terminal.new
    assert_not terminal.valid?
  end

  test "name should be less than 255" do
    terminal = Terminal.new(tenant_id: @tenant.id)
    terminal.name = "1" * 256
    assert_not terminal.valid?
    terminal.name = "1" * 255
    assert terminal.valid?
  end

  test "should generate tokens after create" do
    terminal = Terminal.new(name: 'foobar')
    terminal.tenant_id = @tenant.id
    terminal.save
    terminal.reload
    assert_match /[a-zA-Z0-9]{24}/, terminal.pairing_token
    assert_match /[a-zA-Z0-9]{24}/, terminal.access_token
  end

end
