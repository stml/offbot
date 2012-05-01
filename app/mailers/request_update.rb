class RequestUpdate < ActionMailer::Base 
  def request_update(email_message)
    @person = email_message.person
    @name = email_message.person.name
    @project = email_message.project
    mail(:to => @person.email, :from => "offbott.#{email_message.message_id}@offbott.com", :subject => "Oh no, another update request!")
  end
end
