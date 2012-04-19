class ListenerController < ApplicationController
	skip_before_filter :verify_authenticity_token
  
  def receive_email
  	# do i need this? *scratches head*
    @params = params
    
    sent_to = params["to"].split('@')
    message_id = sent_to[0].split('.')[0]
    email_message = EmailMessage.find_by_message_id(message_id)
    person = email_message.person
    project = email_message.project
    @update = Update.new(:body => params["text"], :email_message_id => email_message.id, :person_id => person.id, :project_id => project.id)
                          
    respond_to do |format|
      if @update.save && request.post?
        flash[:notice] = 'Sucessful Post.'
        format.xml { render :xml => @update.xml, :status => :ok  }
      else
        flash[:error] = 'There was an error with saving the post'
        format.xml { render :xml => @update.errors, :status => :unprocessable_entry }
      end
    end
  
  end
  
  private
  # useful
  def clean_field(input_string)
    input_string.gsub(/\n/, '') if input_string
  end
end