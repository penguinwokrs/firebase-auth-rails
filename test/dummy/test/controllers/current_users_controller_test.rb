require 'test_helper'

class CurrentUsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:valid_user)
    jwt = JSON.parse(File.read(file_fixture('jwt.json')))
    @token = jwt['jwt_token']
    @certificate = JSON.parse(File.read(file_fixture('certificates.json')))
  end

  def authenticate token: @token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
  end

  test "responds with 404 if user is not logged in" do
    get :show
    assert_response :not_found
  end

  test "responds with 200" do
    authenticate
    FirebaseIdToken::Certificates.stub_any_instance(:local_certs, @certificate) do
      get :show
      assert_response :success

      # ttl test
      FirebaseIdToken::Certificates.new.redis.expire("certificates", 0)
      get :show
      assert_response :success
    end
  end
end
