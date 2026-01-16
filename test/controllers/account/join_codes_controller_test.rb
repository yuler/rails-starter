require "test_helper"

class Account::JoinCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:john_account)
    @identity = identities(:john)
    @user = users(:john)
    @join_code = @account.join_code || @account.create_join_code!
  end

  test "should get show" do
    get account_join_code_url(script_name: @account.slug_path), headers: sign_in_as(@identity)
    assert_response :success
  end

  test "should get edit as admin" do
    @user.update!(role: :admin)
    get edit_account_join_code_url(script_name: @account.slug_path), headers: sign_in_as(@identity)
    assert_response :success
  end

  test "should not get edit as member" do
    @user.update!(role: :member)
    get edit_account_join_code_url(script_name: @account.slug_path), headers: sign_in_as(@identity)
    assert_response :forbidden
  end

  test "should update usage_limit as admin" do
    @user.update!(role: :admin)
    patch account_join_code_url(script_name: @account.slug_path),
          params: { account_join_code: { usage_limit: 500 } },
          headers: sign_in_as(@identity)

    assert_redirected_to account_join_code_url(script_name: @account.slug_path)
    assert_equal 500, @join_code.reload.usage_limit
  end

  test "should reset join code as admin" do
    @user.update!(role: :admin)
    old_code = @join_code.code

    delete account_join_code_url(script_name: @account.slug_path), headers: sign_in_as(@identity)

    assert_redirected_to account_join_code_url(script_name: @account.slug_path)
    assert_not_equal old_code, @join_code.reload.code
  end
end
