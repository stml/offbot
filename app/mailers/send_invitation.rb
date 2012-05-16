class SendInvitation < ActionMailer::Base
  default :from => "joinoffbott@#{DOMAIN}", :css => :email
  def send_out_invite(invite)
    @email = invite.email
    mail(:to => @email, :from => "joinoffbott@#{DOMAIN}", :subject => "Hi! Someone invited you to join Offbott")
  end
end
