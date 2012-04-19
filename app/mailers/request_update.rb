class RequestUpdate < ActionMailer::Base 
  def request_update(email_message)
    @person = email_message.person
    mail(:to => @person.email, :from => "offbott-#{@email_message.message_id}@offbott.com", :subject => "Update request")
  end
end
