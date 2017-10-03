require "test_helper"

class AlertServiceTest < ActiveSupport::TestCase
  def setup
    @record = AlertService.new
    @record.company_id = companies(:spectre).id
    @record.user_id = users(:eo).id
  end

  test "sets created as initial state" do
    assert_have_state @record, :created
  end

  test "sets opened from created state" do
    assert_transitions_from @record, :created, to: :opened, on_event: :open
  end

  test "sets closed from opened state" do
    assert_transitions_from @record, :opened, to: :closed, on_event: :close
  end

  test "persists alert" do
    assert_difference "Alert.count" do
      assert @record.open!
    end
  end

  test "creates notifications for users" do
    assert_difference "Notification.count", 2 do
      assert @record.open!
    end
  end
end
