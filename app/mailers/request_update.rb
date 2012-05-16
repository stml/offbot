class RequestUpdate < ActionMailer::Base 
	helper :application
	default :css => :email
  def request_update(email_message)
    @person = email_message.person
    @name = email_message.person.name
    @project = email_message.project
    mail(:to => @person.email, :from => "offbott.#{email_message.message_id}@#{DOMAIN}", :subject => "[#{@project.name}] Hello, it's Offbott again")
  end

  class Preview < MailView
    # Pull data from existing fixtures
    def request_update
    	@email_message = EmailMessage.last
    	@person = @email_message.person
	    @name = @email_message.person.name
	    @project = @email_message.project
      RequestUpdate.request_update(@email_message)
      # ::Notifier.invitation(inviter, invitee)  # May need to call with '::'
    end

  end
end
