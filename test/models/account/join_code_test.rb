require "test_helper"

class Account::JoinCodeTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:john_account)
  end

  test "join code is created with account" do
    account = Account.create!(name: "Test Account", personal: false)
    assert account.join_code.present?
    assert account.join_code.code.present?
  end

  test "code format is XXXX-XXXX-XXXX" do
    @account.create_join_code!
    assert_match(/\A[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}\z/, @account.join_code.code)
  end

  test "active? returns true when usage_count is less than usage_limit" do
    join_code = @account.join_code || @account.create_join_code!
    join_code.update!(usage_count: 0, usage_limit: 100)
    assert join_code.active?
  end

  test "active? returns false when usage_count equals usage_limit" do
    join_code = @account.join_code || @account.create_join_code!
    join_code.update!(usage_count: 100, usage_limit: 100)
    assert_not join_code.active?
  end

  test "redeem_if increments usage_count when active and block returns true" do
    join_code = @account.join_code || @account.create_join_code!
    join_code.update!(usage_count: 0, usage_limit: 100)

    join_code.redeem_if { |account| true }

    assert_equal 1, join_code.reload.usage_count
  end

  test "redeem_if does not increment when block returns false" do
    join_code = @account.join_code || @account.create_join_code!
    join_code.update!(usage_count: 0, usage_limit: 100)

    join_code.redeem_if { |account| false }

    assert_equal 0, join_code.reload.usage_count
  end

  test "redeem_if does not increment when not active" do
    join_code = @account.join_code || @account.create_join_code!
    join_code.update!(usage_count: 100, usage_limit: 100)

    join_code.redeem_if { |account| true }

    assert_equal 100, join_code.reload.usage_count
  end

  test "reset generates new code and resets usage_count" do
    join_code = @account.join_code || @account.create_join_code!
    old_code = join_code.code
    join_code.update!(usage_count: 50)

    join_code.reset

    assert_not_equal old_code, join_code.code
    assert_equal 0, join_code.usage_count
  end
end
