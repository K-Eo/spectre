require 'test_helper'

class TerminalTest < ActiveSupport::TestCase

  test "should be invalid" do
    terminal = Terminal.new
    assert_not terminal.valid?
  end

  test "name should be less than 255" do
    terminal = Terminal.new
    terminal.name = "1" * 256
    assert_not terminal.valid?
    terminal.name = "1" * 255
    assert terminal.valid?
  end

end
