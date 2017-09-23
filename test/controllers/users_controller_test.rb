require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  class Index < UsersControllerTest

    def nuke(as)
      sign_in users(as) unless as.nil?
      get users_path
    end

    test "admin and moderator can visit index" do
      nuke(:eo)
      assert_response :success

      nuke(:kat)
      assert_response :success

      nuke(:jo)
      assert_response :unauthorized
    end

    test "guest user is redirected to login" do
      nuke(nil)
      assert_redirected_to new_user_session_path
    end
  end

  class New < UsersControllerTest

    def nuke(user)
      sign_in users(user) unless user.nil?
      get new_user_path
    end

    test "admin and moderator can visit new" do
      nuke(:eo)
      assert_response :success

      nuke(:kat)
      assert_response :success

      nuke(:jo)
      assert_response :unauthorized
    end

    test "guest user is redirected to login" do
      nuke(nil)
      assert_redirected_to new_user_session_path
    end
  end

  class Create < UsersControllerTest

    def create_user(as, email = 'foo@bar.com')
      sign_in(users(as)) if as.present?
      params = { user: { email: email } }
      post users_path, params: params
    end

    test "guest user is redirected to login" do
      create_user(nil)
      assert_redirected_to new_user_session_path
    end

    test "admin and moderator can create new user" do
      create_user(:eo)
      assert_response :redirect

      create_user(:kat, 'bar@bar.com')
      assert_response :redirect

      create_user(:jo, 'baz@bar.com')
      assert_response :unauthorized
    end

    test "user is persisted into creator company scope as a user" do
      create_user(:eo)
      user = User.find_by(email: 'foo@bar.com')
      assert_equal user.company_id, users(:eo).company_id
      assert user.user?
    end

    test "sets flash if user data is valid" do
      create_user(:eo)
      assert_match /Email sent to/, flash[:success]
    end

    test "renders error if email is invalid" do
      create_user(:eo, '')
      assert_match /is invalid/, @response.body
    end

    test "responds with unprocessable entity if email is invalid" do
      create_user(:eo, '')
      assert_response :unprocessable_entity
    end

    test "responds with bad request if user param is blank" do
      sign_in users(:eo)
      post users_path
      assert_response :bad_request
    end

    test "sets flash if user param is blank" do
      sign_in users(:eo)
      post users_path
      assert_match /Email required/, flash[:alert]
    end
  end

  class Show < UsersControllerTest

    def nuke(as, who)
      sign_in users(as) unless as.nil?
      get user_path(users(who))
    end

    test "users can't see profile of other companies" do
      nuke(:eo, :mia)
      assert_response :not_found

      nuke(:kat, :lee)
      assert_response :not_found

      nuke(:jo, :tom)
      assert_response :not_found
    end

    test "admin can see any profile" do
      nuke(:eo, :eo)
      assert_response :success

      nuke(:eo, :kat)
      assert_response :success

      nuke(:eo, :jo)
      assert_response :success
    end

    test "moderator can see any profile" do
      nuke(:kat, :eo)
      assert_response :success

      nuke(:kat, :kat)
      assert_response :success

      nuke(:kat, :leo)
      assert_response :success

      nuke(:kat, :jo)
      assert_response :success
    end

    test "user can see only his own profile" do
      nuke(:jo, :eo)
      assert_response :unauthorized

      nuke(:jo, :kat)
      assert_response :unauthorized

      nuke(:jo, :case)
      assert_response :unauthorized

      nuke(:jo, :jo)
      assert_response :success
    end
  end

  class Profile < UsersControllerTest

    def setup
      @params = { profile: { first_name: 'foo', last_name: 'bar' } }
    end

    def nuke(as, who)
      sign_in users(as) unless as.nil?
      target = users(who)
      patch profile_user_path(target),
            params: @params,
            xhr: true
    end

    test "user can update only his own profile" do
      nuke(:jo, :eo)
      assert_response :unauthorized

      nuke(:jo, :kat)
      assert_response :unauthorized

      nuke(:jo, :case)
      assert_response :unauthorized

      nuke(:jo, :jo)
      assert_response :success
    end

    test "moderator can update only users and own profile" do
      nuke(:kat, :eo)
      assert_response :unauthorized

      nuke(:kat, :leo)
      assert_response :unauthorized

      nuke(:kat, :kat)
      assert_response :success

      nuke(:kat, :jo)
      assert_response :success
    end

    test "admin can update any profile" do
      nuke(:eo, :eo)
      assert_response :success

      nuke(:eo, :kat)
      assert_response :success

      nuke(:eo, :jo)
      assert_response :success
    end

    test "users can't update profiles of other companies" do
      nuke(:eo, :tom)
      assert_response :not_found

      nuke(:kat, :tom)
      assert_response :not_found

      nuke(:jo, :tom)
      assert_response :not_found
    end

    test "returns javascript on success" do
      nuke(:eo, :eo)
      assert_response :success
      assert_equal 'text/javascript', @response.content_type
    end

    test "returns javascript on failure" do
      @params = nil
      nuke(:eo, :eo)
      assert_response :bad_request
      assert_equal 'text/javascript', @response.content_type
    end
  end

  class Geo < UsersControllerTest

    def setup
      @params = { geo: { lat: 22.22, lng: -24.44 } }
    end

    def nuke(as, who)
      sign_in users(as) unless as.nil?
      target = users(who)
      patch geo_user_path(target),
            params: @params,
            xhr: true
    end

    test "admin can update geo from any account" do
      nuke(:eo, :eo)
      assert_response :success

      nuke(:eo, :kat)
      assert_response :success

      nuke(:eo, :jo)
      assert_response :success
    end

    test "moderator can update geo from own and users account" do
      nuke(:kat, :eo)
      assert_response :unauthorized

      nuke(:kat, :leo)
      assert_response :unauthorized

      nuke(:kat, :kat)
      assert_response :success

      nuke(:kat, :jo)
      assert_response :success
    end

    test "user can update geo from only own account" do
      nuke(:jo, :eo)
      assert_response :unauthorized

      nuke(:jo, :kat)
      assert_response :unauthorized

      nuke(:jo, :case)
      assert_response :unauthorized

      nuke(:jo, :jo)
      assert_response :success
    end

    test "any can't update geo from users of other companies" do
      nuke(:eo, :tom)
      assert_response :not_found

      nuke(:kat, :tom)
      assert_response :not_found

      nuke(:jo, :tom)
      assert_response :not_found
    end

    test "returns javascript on success" do
      nuke(:eo, :eo)
      assert_response :success
      assert_equal 'text/javascript', @response.content_type
    end

    test "returns javascript on failure" do
      @params = nil
      nuke(:eo, :eo)
      assert_response :bad_request
      assert_equal 'text/javascript', @response.content_type
    end
  end

  class Destroy < UsersControllerTest

    def nuke(as, who)
      sign_in users(as)
      delete user_path(users(who))
    end

    test "admin can destroy any user but himself" do
      nuke(:eo, :eo)
      assert_response :unauthorized

      nuke(:eo, :kat)
      assert_response :redirect

      nuke(:eo, :jo)
      assert_response :redirect
    end

    test "moderator can destroy only users and himself" do
      nuke(:kat, :eo)
      assert_response :unauthorized

      nuke(:kat, :leo)
      assert_response :unauthorized

      nuke(:kat, :kat)
      assert_response :redirect

      nuke(:kat, :jo)
      assert_response :redirect
    end

    test "user can destroy only himseld" do
      nuke(:jo, :eo)
      assert_response :unauthorized

      nuke(:jo, :leo)
      assert_response :unauthorized

      nuke(:jo, :case)
      assert_response :unauthorized

      nuke(:jo, :jo)
      assert_response :redirect
    end

    test "users can't destroy users from other company" do
      nuke(:eo, :tom)
      assert_response :not_found
    end
  end
end
