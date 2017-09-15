require 'test_helper'

class WorkerFormTest < ActiveSupport::TestCase

  def setup
    @user = users(:jo)
    @form = WorkerForm.new
    @email = 'foo@bar.com'
    ActsAsTenant.current_tenant = companies(:spectre)
  end

  def teardown
    ActsAsTenant.current_tenant = nil
  end

  def submit
    params = { worker: { email: @email } }
    @form.submit(make_params(params))
  end

  test "submit returns true" do
    assert submit
  end

  test "submit sends email with credentials" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      submit
    end

    invite_email = last_email

    assert_equal 'foo@bar.com', invite_email.to[0]
    assert_match /#{@form.password}/, invite_email.text_part.body.to_s
    assert_match /#{@form.password}/, invite_email.html_part.body.to_s
  end

  test "submit skips confirmation" do
    submit
    worker = User.find_by(email: @email)
    assert worker.confirmed_at
  end

  test "submit creates worker in current company" do
    submit
    worker = User.find_by(email: @email)
    assert_equal worker.company_id, @user.company_id
  end

  test "returns false if email is invalid" do
    @email = "1234"
    assert_not submit
  end

  test "submit returns false if email already exists in same company" do
    @email = 'jo@spectre.com'
    assert_not submit
  end

  test "submit returns false if email already exists in other company" do
    @email = 'lee@ghost.com'
    assert_not submit
  end

end
