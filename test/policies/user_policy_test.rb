require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase

  test "index only for admin or moderator" do
    assert UserPolicy.new(users(:eo), User).index?
  end

end
