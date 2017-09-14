require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @company = Company.new(name: 'Spectre')
  end

  test "valid when name is present" do
    assert @company.valid?
  end

  test "invalid when name is not present" do
    @company.name = ''
    assert_not @company.valid?
  end

  test "invalid when name is too long" do
    @company.name = 'f' * 256
    assert_not @company.valid?
  end
  
end
