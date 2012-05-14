class ListenerController < ApplicationController
	skip_before_filter :verify_authenticity_token
	skip_before_filter :authenticate_person!
	
	def receive_email
		# do i need this? *scratches head*
		@params = params
		
		sent_to = params["to"].split('@')
		message_id = sent_to[0].split('.')[1]
		sent_by = params["from"].split('<')[1].chop

		puts "Message id: #{message_id}, project: #{sent_to[0].split('.')[0]}"
		puts "Sent by: #{sent_by}"

		if Person.find_by_email_key(message_id)
			# this means that it's unprompted, needs to be processed slightly differently
			person = Person.find_by_email_key(message_id)
			project_slug = sent_to[0].split('.')[0]
			puts "Project slug: #{project_slug}"
			person.projects.each do |project|
				if project.to_slug == project_slug
					@update = Update.new(:body => params["text"], :person_id => person.id, :project_id => project.id)
				end
			end
		else
			# this is a response to an update request
			@email_message = EmailMessage.find_by_message_id(message_id)
			person = @email_message.person
			project = @email_message.project
			puts "Message id: #{@email_message.id}, sent by: #{sent_by}, #{person.email}"
			# people use email aliases. not sure what to do.
			#if sent_by == person.email
				@update = Update.new(:body => params["text"], :person_id => person.id, :project_id => project.id)
			#else 
				@update = Update.new
			#end										
		end

		respond_to do |format|
			if @update.save
				add_association_with_email_message
				flash[:notice] = 'Sucessful Post.'
				format.html
				format.xml { render :xml => @update.xml, :status => :ok  }
				format.json { render :json => @update.json, :status => :ok  }
			else
				flash[:error] = 'There was an error with saving the post'
				format.xml { render :xml => @update.errors, :status => :unprocessable_entry }
				format.json { render :json => @update.errors, :status => :unprocessable_entry }
			end
		end

	end
	
	protected
	# useful
	def clean_field(input_string)
		input_string.gsub(/\n/, '') if input_string
	end

	def add_association_with_email_message
		if @email_message
			@email_message.update = @update
			@email_message.save
		end
	end



end
