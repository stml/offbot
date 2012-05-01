require 'test_helper'

class InvitationTest < ActionMailer::TestCase
  test "send_out_invite" do
    mail = Invitation.send_out_invite
    assert_equal "Send out invite", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
