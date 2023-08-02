require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest

  auth_params = { email: "mail@mail.com", password: "helloWorld", phone: "0701010102" }

  test "create account" do
    assert_difference("User.count") do
      post "/auth/create_account", params: auth_params
      assert_response :created
    end
    assert_no_difference "User.count" do
      post "/auth/create_account", params: { email: "mail@mail.com", password: "", phone: "0701010102" }
    end
  end

  test "login" do
    post "/auth/create_account", params: auth_params
    post "/auth/login", params: auth_params
    assert_response :ok
  end

end
