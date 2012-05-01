class SendInvitation < ActionMailer::Base
  default :from => "joinoffbott@offbott.com"
  def send_out_invite(invite)
    @email = invite.email
    mail(:to => @email, :from => "joinoffbott@offbott.com", :subject => "Hi! Someone invited you to join Offbott")
  end
end
