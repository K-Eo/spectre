require 'test_helper'

class WorkersControllerTest < ActionDispatch::IntegrationTest

  def create_worker(auth = true, email = 'foo@bar.com')
    sign_in(users(:jo)) if auth
    params = { worker: { email: email } }
    post workers_path, params: params
  end

  test "index returns success" do
    sign_in users(:jo)
    get workers_path
    assert_response :success
  end

  test "index redirects to login if logged out" do
    get workers_path
    assert_redirected_to new_user_session_path
  end

  test "create responds with created if worker data is valid" do
    create_worker
    assert_response :created
  end

  test "create sets flash if worker data is valid" do
    create_worker
    assert_match /Email sent to/, flash[:success]
  end

  test "create renders error if email is invalid" do
    create_worker(true, '')
    assert_match /is invalid/, @response.body
  end

  test "create responds with unprocessable entity if email is invalid" do
    create_worker(true, '')
    assert_response :unprocessable_entity
  end

  test "create responds with bad request if worker param is blank" do
    sign_in users(:jo)
    post workers_path
    assert_response :bad_request
  end

  test "create sets flash if worker param is blank" do
    sign_in users(:jo)
    post workers_path
    assert_match /Email required/, flash[:alert]
  end

  test "create redirects to login if logged out" do
    create_worker(false)
    assert_redirected_to new_user_session_path
  end

end
