require 'test_helper'

class AlertFormTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @user = users(:jo)
    @form = AlertForm.new(@user)
    @params = { text: 'foobar' }
  end

  def update
    @form.update(@params)
  end

  test "update returns true" do
    assert update
  end

  test "update creates new alert" do
    assert_difference 'Alert.count' do
      update
    end
  end

  # BUG: Sends 4 of each type because selects all users from all companies
  # FIXME: Should selects only guards users

  # test "update creates alert events" do
  #   assert_difference 'Notice.count', 2 do
  #     update
  #   end
  # end
  #
  # test "update sends alert notifications" do
  #   assert_enqueued_jobs 2 do
  #     update
  #   end
  # end

  test "update returns false if text is too long" do
    text = 'a' * 256
    @params = { text: text }
    assert_not update
  end

end
