require 'test_helper'

class GeoFormTest < ActiveSupport::TestCase

  def setup
    @user = users(:jo)
    @form = GeoForm.new(@user)
    @params = { lat: 17.2695858, lng: -97.6803423 }
  end

  def update
    @form.update(@params)
  end

  test "update returns true" do
    assert update
  end

  test "update sets new lat and lng" do
    update
    @user.reload
    assert_equal 17.2695858, @user.lat
    assert_equal -97.6803423, @user.lng
  end
end
