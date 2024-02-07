require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    user = users(:one)
    mail = UserMailer.with(user: user).welcome

    assert_equal [ user.email ], mail.to
    assert_match "Welcome", mail.subject
    assert_match "Hi", mail.body.encoded
  end
end
