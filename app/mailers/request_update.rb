class RequestUpdate < ActionMailer::Base 
  def request_update(email_message)
    @person = email_message.person
    @name = email_message.person.name
    @project = email_message.project
    mail(:to => @person.email, :from => "offbott.#{email_message.message_id}@#{DOMAIN}", :subject => "[#{@project.name}] Hello, it's Offbott again")
  end
end
