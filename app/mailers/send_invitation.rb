class SendInvitation < ActionMailer::Base
  default :from => "joinoffbott@#{DOMAIN}", :css => :email
  def send_out_invite(invite)
    @email = invite.email
    @projects = invite.projects
    mail(:to => @email, :from => "joinoffbott@#{DOMAIN}", :subject => "Hi! Someone invited you to join Offbott")
  end

  class Preview < MailView
    def send_out_invite
    	@invite = Invitation.last
    	@projects = @invite.projects
    	::SendInvitation.send_out_invite(@invite)
    end

  end
end
