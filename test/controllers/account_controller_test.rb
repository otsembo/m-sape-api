require "test_helper"

class AccountControllerTest < ActionDispatch::IntegrationTest

  party_a = "sample@mail.com"
  party_b = "mail@mail.com"
  account_params = { account: { "amount" => 200 } }
  transfer_params = { account: { "amount" => 200, "user_mail" => party_b } }

  test "top up account" do
    token = create_account
    post "/account/topup", params: account_params , headers: { "Authorization" => "Bearer #{token}"}
    assert_response :success
    post "/account/topup", params: account_params
    assert_response :forbidden
  end

  test "withdraw account" do
    token = create_account
    post "/account/topup", params: account_params , headers: { "Authorization" => "Bearer #{token}"}
    post "/account/withdraw", params: account_params, headers: { "Authorization" => "Bearer #{token}"}
    assert_response :success
    post "/account/withdraw", params: account_params
    assert_response :forbidden
  end

  test "transfer money" do
    token = create_account
    post "/account/topup", params: account_params, headers: { "Authorization" => "Bearer #{token}"}
    assert_no_difference("Transaction.count") do
      post "/account/transfer", params: transfer_params, headers: { "Authorization" => "Bearer #{token}"}
    end
  end

  private

  def create_account
    auth_params = { email: "mail@mail.com", password: "helloWorld", phone: "0701010102" }
    auth_params2 = { email: "sample@mail.com", password: "<PASSWORD>", phone: "0711111011"}
    post "/auth/create_account", params: auth_params
    post "/auth/create_account", params: auth_params2
    JSON.parse(@response.body)["data"]["auth"]
  end

end
