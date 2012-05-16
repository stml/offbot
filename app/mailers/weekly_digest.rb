class WeeklyDigest < ActionMailer::Base
	default :from => "weeklyupdate@#{DOMAIN}", :css => :email
	def weekly_digest(project, person)
		@project = project
		@from = "#{@project.name.gsub(' ', '')}.weeklyupdate@#{DOMAIN}"
		@person = person
		mail(:to => @person.email, :from => @from, :subject => "#{@project.name} Weekly Update")
	end

	class Preview < MailView
    def weekly_digest
    	@project = Project.find_by_name("Happenstance")
			@from = "#{@project.name.gsub(' ', '')}.weeklyupdate@#{DOMAIN}"
			@person = Person.last
    	::WeeklyDigest.weekly_digest(@project, @person)
    end

  end
end
